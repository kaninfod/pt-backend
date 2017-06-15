#!/bin/bash

rake resque:start_workers
tail -f /dev/stdout
