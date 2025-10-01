#!/bin/bash
source /etc/nzyme/common_nzyme_details.sh

announce "Running migration job"
nzyme --migrate-database
