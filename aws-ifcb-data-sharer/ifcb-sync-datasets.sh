#!/bin/bash
# Syncs all IFCBDB datasets from the IFCB Sync AWS pipepline
# Picks up any files that may have missed the initial sync run or are used in multiple Datasets.

# get a list of all dataset names to run operations on 
#datasets=$(find /opt/ifcbdb/ifcbdb/ifcb_data/primary/ifcb-data-sharer -mindepth 2 -maxdepth 2 -type d  \( ! -iname ".*" \))

# ifcbdb instance name
IFCBDB="ifcbdb_ifcbdb_1"
API_LIST_URL="https://habon-ifcb.whoi.edu/api/list_datasets"

# get a list of all dataset names to run operations on from API
datasets=$(curl -s "$API_LIST_URL" | jq -r '.datasets')
readarray -t datasets_array < <(echo "$datasets" | jq -r '.[]')

for item in "${datasets_array[@]}"; do
    # set its data directory
    if [[ ! "$item" == "mvco" ]]; then
        echo "sync ifcb data"
        echo $item
        docker exec $IFCBDB python manage.py syncdataset $item
    fi
done

# loop through datasets, split string to last element
for i in $datasets; do
    # use last directory string elemement for title
    dataset_id=$(echo "$i" | awk -F\/ '{print $NF}')
    echo $dataset_id

    # sync ifcb data
    echo "sync ifcb data"
    docker exec $IFCBDB python manage.py syncdataset $dataset_id

    # run a second check to sync datasets using old naming convention "user_datasetid"
    # get user from directory string, second to last
    user=$(echo "$i" | awk '{split($0,a,"/"); print a[8]}')
    # split directory name into user and dataset title, concat to use as the unique id
    dataset_old_id=$(echo "$i" | awk '{split($0,a,"/"); new_var=a[8]"_"a[9]; print new_var}')
    echo $dataset_old_id

    # sync ifcb data
    echo "sync ifcb data"
    docker exec $IFCBDB python manage.py syncdataset $dataset_old_id

done
