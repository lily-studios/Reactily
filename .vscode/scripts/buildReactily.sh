#!/bin/sh

set -eu

repositoryRoot="$(git rev-parse --show-toplevel)"
cd "$repositoryRoot"

python3 .vscode/scripts/generateInit.py

mkdir -p dist

rojo build model.project.json \
	-o dist/Reactily.rbxm
