#!/bin/bash
set -euo pipefail
source /etc/nzyme/common_nzyme_details.sh

# Keep Nzyme as PID 1 so Docker sees its exit status and forwards signals.
exec nzyme
