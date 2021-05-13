#!/bin/bash

set -eoux pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: `populate_db.sh <path>`"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
DB=$SCRIPT_DIR/../$1
SOURCE_DIR=$SCRIPT_DIR/../csvs/

rm -rf $DB

for FILE in $SOURCE_DIR/*.csv; do
    if [ ! -d $DB ]; then
        mkdir -p $DB
        cd $DB
        dolt init
        dolt schema import --create --pks=Location latest_sale $FILE
    fi
    dolt table import --update-table ---pks=Location --continue latest_sale $FILE
    dolt status
    dolt commit -am "Import $FILE"
done

