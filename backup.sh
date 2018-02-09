#!/bin/bash

MONGO_HOST="localhost"
MONGO_PORT="27017"

TIMESTAMP=`date +%F-%H%M`
S3_BUCKET_NAME="my-mongodb-backup"
FILENAME="mongodb-$TIMESTAMP"

# Create backup
mongodump --oplog -h $MONGO_HOST:$MONGO_PORT -u admin -p $(aws ssm get-parameters --names MongoDB --region us-west-2 --query "Parameters[0].Value") --out ./$FILENAME

# Add timestamp to backup
tar cf $FILENAME.tar $FILENAME

# Upload to S3
aws s3api put-object --bucket $S3_BUCKET_NAME --key $FILENAME.tar --body $FILENAME.tar

# Cleanup files
rm -rf $FILENAME $FILENAME.tar
