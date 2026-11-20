package main

import (
	"crypto/tls"
	"crypto/x509"
	_ "embed"
	"log"
	"net/http"
	"sync"
	"time"

	awshttp "github.com/aws/aws-sdk-go-v2/aws/transport/http"
	"github.com/aws/aws-sdk-go-v2/config"
)

// embeddedCACerts is Mozilla's CA bundle as published by curl
// (https://curl.se/ca/cacert.pem). It is compiled into the binary so TLS
// verification works on hosts with outdated OS CA bundles. Refresh it
// periodically with ./update-ca-certs.sh and rebuild.
//
//go:embed certs/cacert.pem
var embeddedCACerts []byte

var (
	rootCAsOnce sync.Once
	rootCAs     *x509.CertPool
)

// rootCAPool returns the OS root certificates plus the embedded Mozilla
// bundle, so a certificate trusted by either one verifies.
func rootCAPool() *x509.CertPool {
	rootCAsOnce.Do(func() {
		pool, err := x509.SystemCertPool()
		if err != nil || pool == nil {
			pool = x509.NewCertPool()
		}
		if !pool.AppendCertsFromPEM(embeddedCACerts) {
			log.Println("Warning: no certificates loaded from embedded CA bundle")
		}
		rootCAs = pool
	})
	return rootCAs
}

// newAPIClient returns the HTTP client used for the dataset API.
func newAPIClient(insecureSkipVerify bool) *http.Client {
	return &http.Client{
		Timeout: 30 * time.Second,
		Transport: &http.Transport{
			Proxy: http.ProxyFromEnvironment,
			TLSClientConfig: &tls.Config{
				RootCAs:            rootCAPool(),
				InsecureSkipVerify: insecureSkipVerify,
			},
		},
	}
}

// withEmbeddedCAs is an AWS config option that makes the SDK verify
// certificates against rootCAPool() instead of only the OS bundle.
func withEmbeddedCAs() config.LoadOptionsFunc {
	client := awshttp.NewBuildableClient().WithTransportOptions(func(tr *http.Transport) {
		if tr.TLSClientConfig == nil {
			tr.TLSClientConfig = &tls.Config{}
		}
		tr.TLSClientConfig.RootCAs = rootCAPool()
	})
	return config.WithHTTPClient(client)
}
