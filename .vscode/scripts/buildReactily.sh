#!/bin/sh

# Reactily · Lily Studios
# Copyright (c) Lily Studios and contributors.
# Licensed under the MIT License.
# See LICENSE in the repository root for full terms.

set -eu

repositoryRoot="$(git rev-parse --show-toplevel)"

cd "$repositoryRoot"

python3 .vscode/scripts/generateInit.py

mkdir -p dist

rojo build model.project.json \
	-o dist/Reactily.rbxm
