#!/bin/bash
source /etc/nzyme/common_nzyme_details.sh

nzyme &
while [ ! -f "$NZYME_LOG_FILE" ]; do
     sleep 1
done
tail -f "$NZYME_LOG_FILE"
