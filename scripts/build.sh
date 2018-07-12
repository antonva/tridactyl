#!/bin/sh

set -e

CLEANSLATE="node_modules/cleanslate/docs/files/cleanslate.css"

isWindowsMinGW() {
  local is_mingw="False"
  if [ "$(uname | cut -c 1-5)" = "MINGW" ] \
    || [ "$(uname | cut -c 1-4)" = "MSYS" ]; then
    is_mingw="True"
  fi

  echo -n "${is_mingw}"
}

if [ "$(isWindowsMinGW)" = "True" ]; then
  WIN_PYTHON="py -3"
  NPM_BIN_DIR="$(cygpath $(npm bin))"
  PATH=$NPM_BIN_DIR:$PATH
else
  PATH="$(npm bin):$PATH"
fi

export PATH

mkdir -p build
mkdir -p build/static
mkdir -p generated/static
mkdir -p generated/static/clippy

if [ "$(isWindowsMinGW)" = "True" ]; then
  $WIN_PYTHON scripts/excmds_macros.py
else
  scripts/excmds_macros.py
fi
scripts/newtab.md.sh
scripts/make_tutorial.sh
scripts/make_docs.sh &

for f in src/grammars/*.ne
do
  $(npm bin)/nearleyc $f -o src/grammars/.$(basename $f .ne).generated.ts
done

if [ "$(isWindowsMinGW)" = "True" ]; then
  powershell \
    -NoProfile \
    -InputFormat None \
    -ExecutionPolicy Bypass \
    native/install.ps1 -DebugDirBase native
else
  native/install.sh local
fi

(webpack --display errors-only \
  && scripts/git_version.sh) &

wait

scripts/bodgecss.sh
scripts/authors.sh

if [ -e "$CLEANSLATE" ] ; then
	cp -v "$CLEANSLATE" build/static/css/cleanslate.css
else
	echo "Couldn't find cleanslate.css. Try running 'npm install'"
fi
