#!/usr/bin/env bash
set -e

THIS="$(readlink -f "$0")"
THISDIR="${THIS%/*}"

ln -svf "$THISDIR/.bashrc" "$HOME/"
ln -svf "$THISDIR/.bash_aliases" "$HOME/"
echo "Done! Remember that local config should got to ~/.bash_private"
