#!/bin/bash

cat /proc/sys/kernel/random/uuid | sed 's/\-//g'
