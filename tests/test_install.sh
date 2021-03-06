#!/usr/bin/env bash

# This script assumes we have cookiecutter, sphinx, setuptools_git on our path already

# Cross-platform temporary directory
# See http://unix.stackexchange.com/a/84980/100136
mytmpdir=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`

function finish {
    rm -rf "$mytmpdir"
}
trap finish EXIT

cookiecutterdir=`pwd`

cd "$mytmpdir"
cookiecutter "$cookiecutterdir" --no-input
cd myscipkg
git init
git add -A
git commit -am "Test commit"
git tag 0.1

# Using home-spun testing code here, exiting if the string
# comparison is different from what we expect
version="$(python setup.py --version)"
echo "$version"
expversion="0.1"
if [[ "$version" != "$expversion" ]]; then
    echo "package version $version != $expversion"; exit 1;
fi

python setup.py install
python setup.py test

# See what happens if we try to build the docs
invoke build_docs
