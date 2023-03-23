#!/usr/bin/env bash
mkdir docs/software/
cd roles
for dir in *; do
    echo "$dir"
    cp $dir/docs.md ../docs/software/$dir.md
done
