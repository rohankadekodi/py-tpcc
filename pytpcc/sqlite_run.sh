#!/bin/bash

strace python ./tpcc.py --no-load --duration=10 --config=sqlite.config sqlite
