## IFCB-sync command reference

IFCB-sync is a command line application. To display the built-in help and a summary of available commands:

```bash
ifcb-sync --help
```

---

### Start live synchronization of new data

```text
ifcb-sync start <directory> <dataset>
```

Starts IFCB-sync as a background process. *Existing files are ignored.*  The target directory is monitored for the creation of new files. On creation, files are transferred to <dataset> and should be available to view on the HABON IFCB Dashboard within 15-20 minutes of initial file write on IFCB.  

Transfer progress and diagnostic messages are written to `ifcb-file-watcher` log files in the IFCB-sync application directory (typically `/home/ifcb/ifcb-sync`). 

**Arguments**

| Argument | Description |
|----------|-------------|
| `<directory>` | Absolute or relative path to the IFCB data directory (e.g., `/home/ifcb/ifcbdata`). |
| `<dataset>` | Name of the destination dataset in HABON IFCB Dashboard (e.g., `nauset`). The dataset must already exist and belong to the configured `USER_ACCOUNT`. |

To create a new dataset, use [Dataset Management](docs/dashboard.md#dataset-creation-in-habon-ifcb-dashboard) in the HABON-NE IFCB Dashboard.

---

### Stop live synchronization of new data

```text
ifcb-sync stop <directory | dataset>
```

Stops an active transfer process associated with the specified directory or dataset. Either argument may be supplied.

---

### List datasets

```text
ifcb-sync list
```

Lists all datasets associated with the configured `USER_ACCOUNT`.

---

### One-time file synchronization

```text
ifcb-sync sync <directory> <dataset>
```

Transfers **existing** IFCB files in the specified directory and then exits. Unlike `start`, this command does **not** continue monitoring the directory for new files.

Arguments are identical to those used by `start`.

---


### List active `ifcb-sync` processes

```text
ifcb-sync status
```

View a list of current ifcb-sync processes and their status ('Running' or 'Stale')


---


### Example

An IFCB operated by Team `hablab` writes data to directory

```text
/home/ifcb/ifcbdata/nauset_data
```

and the dataset `nauset` has already been created in HABON IFCB Dashboard.

Start continuous synchronization:

```bash
ifcb-sync start /home/ifcb/ifcbdata/nauset_data/2026 nauset
```

New samples will be uploaded automatically as they are written to disk and published at <https://habon-ifcb.whoi.edu/nauset>.


Before shutting down the instrument or switching to another dataset, stop synchronization:

```bash
ifcb-sync stop nauset
```

> **Important**

>

> Always stop IFCB-sync before repurposing an instrument or data directory. Otherwise, subsequently acquired samples may be uploaded to the wrong dataset.

---

### Notes

- IFCB-sync uploads files from the specified directory and all subdirectories within it. **If collecting bead samples at a regular interval, it is helpful to configure your IFCB to write data in 'Tree' format (year/yearday subdirectories). Then point ifcb-sync to the year subdirectory.**

- Files already present in Dashboard are not re-uploaded.

- Deleting local files does **not** remove them from a dataset on the HABON IFCB Dashboard. Reorganization or removal of bins from a dataset is completed using [Bin Management](docs/dashboard.md#bin-management).



