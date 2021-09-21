#!/bin/bash

ping -I $1 -w 1 $2 > /dev/null
echo $?
