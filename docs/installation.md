# Installation

IFCB-sync can be installed either directly on an IFCB sensor running Debian Linux or on a separate server running Debian Linux, macOS, or Windows. The installation steps are almost identical across these operating systems. Differences are described within the sections below under the subheadings for each OS.

## 1. Contact mbrosnahan@whoi.edu to request a IFCB Dashboard account and receive access credentials.

A new Team account will be created for you on WHOI HABlab's [IFCB Dashoard application](https://habon-ifcb.whoi.edu). This will allow you to manage your own IFCB data on the IFCB Dashboard by creating Datasets and adding Team Members. Before you use the ifcb-sync tool to add data from your IFCB host, make sure to first create the Dataset to receive the data in the IFCB Dashboard.

You will also receive separeate AWS credentials for use with the ifcb-sync tool as described below.

## 2. Ensure that Git is installed on your host.

### Linux

In a terminal:

```
sudo apt update
sudo apt install git
```

### Mac

Download and install Xcode through the [Mac App store](https://apps.apple.com/us/app/xcode)

### Windows

Download and install [Git for Windows](https://git-scm.com/download/win). During installation, be sure to enable symbolic links.

## 3. Install the `ifcb-sync` script.

### IFCB sensor installation

In a terminal:

```
cd /home/ifcb
git clone https://github.com/WHOIGit/ifcb-sync.git
cd ifcb-sync
chmod +x ifcb-sync
sudo ln -s /home/ifcb/ifcb-sync/ifcb-sync /usr/local/bin/
```

### Linux and MacOS server installations

In a terminal:

```
git clone https://github.com/WHOIGit/ifcb-sync.git
cd ifcb-sync
INSTALLDIR=$(pwd)
chmod +x ifcb-sync
sudo ln -s "$INSTALLDIR/ifcb-sync" /usr/local/bin/
```

### Windows server installation

Open a terminal windown in `Git Bash` using 'as an Administrator' option. Right click icon in start menu > 'More' > 'Run as administrator'.
In the terminal window:

```
git clone https://github.com/WHOIGit/ifcb-sync.git
cd ifcb-sync
chmod +x ifcb-sync
mkdir -p /usr/local/bin
```

Create a Windows symlink for ifcb-sync.
Open and run `cmd.exe` as an administrator, then in the new terminal window:

```
cd C:\Program Files\Git\usr\local\bin
mklink ifcb-sync C:\path\to\ifcb-sync\ifcb-sync
```

where `C:\path\to\ifcb-sync` is the location where this repo was cloned. Default is `C:\Users\USERNAME\ifcb-sync`.

## 4. Create a new `.env` file in the same directory. In a terminal, copy the example code from the `.env.example`. Use Git Bash terminal if installing on a Windows host.

```
cp .env.example .env
```

## 5. Update the .env variables to the AWS Key/AWS Secret/User Account that you received from WHOI using a text editor (e.g., `nano .env`).

```
AWS_ACCESS_KEY_ID=your-key-here
AWS_SECRET_ACCESS_KEY=your-secret-here
USER_ACCOUNT=your-user-account
```

