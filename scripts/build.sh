#!/bin/sh

set -e

PATH=$(npm bin):"$PATH"
export PATH

mkdir -p generated/static
scripts/excmds_macros.py
scripts/newtab.md.sh
scripts/make_docs.sh &

(webpack --display errors-only && scripts/git_version.sh)&

wait
