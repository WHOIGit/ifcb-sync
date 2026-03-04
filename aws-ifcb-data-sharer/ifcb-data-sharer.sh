#!/bin/bash

ENV_FILE=".env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    # Enable automatic export of all subsequent assignments
    set -o allexport
    # Source the file to load variables into the current shell environment
    source "$ENV_FILE"
    # Disable automatic export
    set +o allexport
    echo "Environment variables loaded from $ENV_FILE"
else
    # default values to work on HABON IFCB
    echo "$ENV_FILE not found. Set default vars"
    API_LIST_URL="https://habon-ifcb.whoi.edu/api/list_datasets"
    API_SYNC_URL="https://habon-ifcb.whoi.edu/api/sync_bin"
    S3_BUCKET="s3://ifcb-data-sharer.files"
    LOCAL_FILE_DIR="/opt/ifcbdb/ifcbdb/ifcb_data/primary/ifcb-data-sharer"
    # Docker container name
    IFCBDB="ifcbdb_ifcbdb_1"
    # Path in Docker container to data directory
    DOCKER_PRIMARY_DATA_DIR="/data/primary/ifcb-data-sharer"
fi

#export AWS_PROFILE=ifcb-data-sharer
# sync local directory with files in S3, delete any files that don't match as well
aws s3 sync $S3_BUCKET $LOCAL_FILE_DIR  \
    --delete --no-progress > clean_log.txt

# get a list of all local dataset names to run operations on 
datasets=$(find $LOCAL_FILE_DIR -mindepth 2 -maxdepth 2 -type d  \( ! -iname ".*" \))

# loop through datasets, add data directory to IFCBDB
for i in $datasets; do
    echo $i
    # get user from directory string, second to last
    user=$(echo "$i" | awk -F/ '{print $(NF-1)}')
    # use last directory string elemement for title
    dataset_id=$(echo "$i" | awk -F\/ '{print $NF}')

    echo $dataset_id
    echo $user

    # set its data directory
    echo "set dataset's data directory"
    docker exec $IFCBDB python manage.py adddirectory -k raw $DOCKER_PRIMARY_DATA_DIR/$user/$dataset_id $dataset_id
    
    # Add blobs path
    echo "set dataset's blob directory"
    docker exec $IFCBDB python manage.py adddirectory -k blobs -p 4 /data/products/blobs-v4 $dataset_id

    # Add features path
    echo "set dataset's features directory"
    docker exec $IFCBDB python manage.py adddirectory -k features -p 4 /data/products/fea-v4/ $dataset_id

    # import metadata if exists
    #echo "import metadata if exists"
    #docker exec $IFCBDB python manage.py importmetadata /data/primary/ifcb-data-sharer/$user/$dataset_title/metadatafile.csv
done

# get a list of all dataset names to run operations on from API
# datasets=$(curl -s "$API_LIST_URL" | jq -r '.datasets')
# readarray -t datasets_array < <(echo "$datasets" | jq -r '.[]')

#for item in "${datasets_array[@]}"; do
#    # set its data directory
#    echo "set dataset's data directory"
#    echo $item
#    docker exec $IFCBDB python manage.py adddirectory -k raw /data/primary/ifcb-data-sharer/$user/$dataset_title $dataset_id
#done

while IFS= read -r line; do
    # parse the AWS CLI output file string
    # only sync if action is "download:"
    action=$(echo "$line" | awk -F' ' '{print $1}')
    echo "$action"
    if [[ "$action" == "download:" ]]; then
        echo "File downloaded, start sync process"
        # use local file path to get dataset/team names
        last_element="${line##* }"
        echo "$last_element"
        dataset_id=$(echo "$last_element" | awk -F'/' '{print $3}')
        echo "$dataset_id"
        bin_file=$(echo "$last_element" | awk -F\/ '{print $NF}')
        bin=$(echo "$bin_file" | awk -F\. '{print $1}')
        echo "$bin"
        curl "$API_SYNC_URL?dataset=$dataset_id&bin=$bin"
    fi
done < "clean_log.txt"