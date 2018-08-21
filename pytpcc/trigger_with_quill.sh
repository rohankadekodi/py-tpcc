#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ./trigger_with_quill.sh <ledger/ext4>"
    exit
fi

set -x

rm -rf /mnt/pmem_emul/* && sync
cp /home/rohan/projects/db_workloads/tpcc.db /mnt/pmem_emul/
sync

if [ "$1" = "ledger" ]; then
    /home/rohan/projects/quill-modified/run_quill.sh -p /home/rohan/projects/quill-modified -t nvp_nvp.tree ./tpcc.py --config=sqlite.config --no-load --duration=30 sqlite
elif [ "$1" = "syscalls" ]; then
    /home/rohan/projects/quill-syscalls/quill-modified/run_quill.sh -p /home/rohan/projects/quill-syscalls/quill-modified -t nvp_nvp.tree ./tpcc.py --config=sqlite.config --no-load --duration=30 sqlite
else
    ./tpcc.py --config=sqlite.config --no-load --duration=30 sqlite
fi
