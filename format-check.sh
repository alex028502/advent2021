#! /usr/bin/env bash

set -e

echo checking format of python files all at once
venv/bin/black . --check


# because it takes so long to start a racket process, and because I don't have
# and easy way to check if multiple files match the recommended format, it is
# much faster to format the files than to check if they are the right format
# to reformat all I just have to
# find . -name '*.rkt' | xargs raco fmt -i
# actually
# find . -name '*.rkt' | xargs ./raco-fmt.sh -i
# but without the -i, I don't know how to reliably compare the output
# maybe I could cat all the files - and hope for the same order - it will
# probably work - but this is fine - 10 seconds - small price to pay for nicely
# formatted files
echo checking format of racket files one by one
for f in $(find . -name '*.rkt')
do
  ls $f # shows file we are checking & fails if it doesn't exist due to spaces
  # --help doens't show a way to make it fail so just going to check myself
  # if the formatted output matches the file
  ./raco-fmt.sh $f | diff - $f -s
  # no unix style output for emacs compile comand so just auto format the file
  # if there is an issue, just like with black
done
