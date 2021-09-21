#!/bin/bash

echo "switch $@"

/usr/sbin/ip r delete default
/usr/sbin/ip r add default via $1 dev $2

