#!/bin/bash


ping -w 1 $1 > /dev/null
echo $?
