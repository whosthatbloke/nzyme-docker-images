#!/bin/bash
set -euo pipefail
source /etc/nzyme/common_nzyme_details.sh

announce "Running migration job"
exec nzyme --migrate-database
