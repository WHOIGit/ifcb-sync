# Concepts

This document introduces the core concepts used throughout IFCB Dashboard and IFCB Sync. Understanding the relationships between Teams, Datasets, Bins, and Images will make the remainder of the documentation easier to follow.

---

## Data organization

IFCB Dashboard organizes data hierarchically. In the Teams-enabled version used by IFCB-sync, this hierarchy is as follows:

```mermaid
flowchart TD
    A[Team]
    B[Dataset<br/>(time series)]
    C[Bin<br/>(sample)]
    D[Sample metadata]
    E[Images (ROIs)]
    F[Bin-level derived products]

    A --> B
    B --> C
    C --> D
    C --> E
    C --> F
```

---

## Teams

A **Team** represents an operator group. Teams own one or more datasets. Captains and Managers within a team manage dataset organization and responsible for data and metadata quality.

Examples include:

* hablab
* nwfsc
* sardi

---

## Datasets

A **Dataset** (sometimes called a *time series*) is a collection of IFCB samples (e.g., a time series at a specific location, a cruise, or set of observations used in a manuscript).

Each dataset has a unique name that appears in Dashboard URLs. 

For example

```
https://habon-ifcb.whoi.edu/harpswell
```

identifies the dataset named `harpswell`.

Datasets are the primary organizational unit used when publishing, browsing, and querying IFCB data. Any individual sample (or Bin) may be associated with one or more data sets.


---

## Bins

Each IFCB sample is called a **bin**.

Every bin has a unique identifier (PID), for example

```
D20210701T152144_IFCB124
```

A bin contains

- sensor-derived sample metadata (HDR and ADC files)
- all images acquired from that sample (ROI file)
- derived products generated from those images

Additional metadata may associated with a bin at acquisition (for example in [PhytO-ARM-based systems](https://github.com/WHOIGit/PhytO-ARM)) or supplied by operator teams later. These metadata may include:

- latitude
- longitude
- depth
- cruise
- tags

---

## Images (ROIs)

The IFCB sensor automatically segments its images and records only the ROI (region of interest) associated with individual particles. Each image in IFCB Dashboard has a stable URL and can be viewed or downloaded independently of other images in its bin. 

For example, the Dashboard page for an individual image is

```
https://habon-ifcb.whoi.edu/image?image=06582&dataset=harpswell&bin=D20210701T152144_IFCB124
```

The corresponding image file may also be downloaded directly, for example

```
https://habon-ifcb.whoi.edu/harpswell/D20210701T152144_IFCB124_06582.png
```

or

```
https://habon-ifcb.whoi.edu/harpswell/D20210701T152144_IFCB124_06582.jpg
```

---

## Bin-level derived products

Many analyses performed on IFCB images produce outputs that describe **every image in a bin**.

These products are therefore distributed as files associated with the entire sample rather than for each individual image. They include machine-generated classifier score and feature matrices. Features are quantitative, morphological measurements extracted from individual ROIs (See the [ifcb-analysis](https://github.com/hsosik/ifcb-analysis) by Heidi Sosik). 

Each row in these files corresponds to one ROI within the sample.

This organization allows efficient retrieval of analysis results while maintaining stable URLs for individual image resources.






