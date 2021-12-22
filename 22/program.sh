#! /usr/bin/env bash

set -e

if [[ "$2" == "" ]]
then
  filter_program=cat
else
  filter_program="racket -t $(dirname $0)/module.rkt -m -- --init-filter"
fi

# I hope I don't have any spaces in any directory names!
# I don't locally, and I am pretty sure github actions doesn't either!

# I don't know what the cost of running two extra 'cat' processes is
# but it helps maximize the amount of code from the main procedure
# that I am testing in the init procedure

set -o pipefail
cat $1 | $filter_program | racket -t $(dirname $0)/module.rkt -m
