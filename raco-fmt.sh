#! /usr/bin/env bash

set -e

# I couldn't find any documentation for .fmt.rkt config file
# so just made a wrapper so that I can easily use the same options locally as
# the format checker users on ci

raco fmt --width 80 $@ # add filename and `-i`
