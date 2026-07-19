# IFCB-sync

IFCB-sync allows Imaging FlowCytobot ([IFCB](https://mclanelabs.com/imaging-flowcytobot/)) operator groups to share their data through an [IFCB dashboard](https://github.com/WHOIGit/ifcbdb.git) hosted at the Woods Hole Oceanographic Institution (https://habon-ifcb.whoi.edu). Depending on how it's invoked, the program either performs a one-time file synchronization or continuosly monitors a specified data directory, uploading any new files created within the directory to <habon-ifcb.whoi.edu> via a cloud-based data pipeline.

The app is tightly integrated with a Teams-enabled instance of IFCB dashboard. Operator groups have full control over how data are shared and organized. They can also update metadata associated with individual samples. Lastly, IFCB-sync automates the generation of commonly used IFCB data products (blobs, features, and machine-based taxonomic classification).


```text
             IFCB Sensor
                  │
                  ▼
              ifcb-sync
                  │
                  ▼
      Cloud-mediated data transfer
                  │
                  ▼
          HABON IFCB Dashboard
           ├── Web interface
           └── URL API
                  │
                  ▼
       Python / R / MATLAB analyses
```


```mermaid
flowchart TD
    A[IFCB Sensor] --> B[ifcb-sync]
    B --> C[Cloud-mediated data transfer]
    C --> D[File integrity verification]
    D --> E[Automated image processing]
    E --> F[Image feature extraction<br/>ifcb-analysis v4]
    E -,-> G[Taxonomic Classification<br/>in development]
    F --> H[HABON IFCB Dashboard<br/>Teams-enabled]
    G --> H
    H --> I[Web interface]
    H --> J[URL API]
    J --> K[Downstream analysis and visualization]
```

## Features

*Continuous synchronization of IFCB data directories for near real-time sharing
*One-time synchronization for upload of previously acquired datasets
*Supports Linux, MacOS, and Windows
*Integrated with Teams version of IFCB Dashboard so that external operator teams can manage dataset organization and metadata independently

## Quick Start
1. Request an account for access to the HABON-IFCB Dashboard
2. Install IFCB Sync
3. Create a dataset through the HABON-IFCB Dashboard
4. Start synchronization

## Documentation
- **[Concepts](docs/concepts.md)** – Overview of Teams, Datasets, Bins, and IFCB Dashboard.
- **[Installation](docs/installation.md)** – Install IFCB Sync and configure credentials.
- **[Command Reference](docs/command-reference.md)** – `start`, `stop`, `sync`, and `list`.
- **[Dashboard Administration](docs/dashboard.md)** – Create datasets, manage bins, and edit metadata.
- **[Accessing Dashboard Data](docs/data-access.md)** – Retrieve metadata, classifier outputs, images, and other products through the URL API. 
