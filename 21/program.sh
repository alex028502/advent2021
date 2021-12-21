#! /usr/bin/env bash

set -e

racket -t $(dirname $0)/module.rkt -m $@
