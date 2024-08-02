#!/usr/bin/env bash
dir="$(readlink -f "$(dirname "$0")")"
set -x
exec m4 -PI"$dir" k.m4 "$@"
