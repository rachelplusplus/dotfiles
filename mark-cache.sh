#!/bin/bash
# Mark a directory as a "cache", which tells most backup tools to ignore it

set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 DIR"
  exit 2
fi

if ! [ -d $1 ]; then
  echo "Error: '$1' is not a directory"
  exit 1
fi

TEXT="Signature: 8a477f597d28d172789f06886806bc55
# This file is a cache directory tag created by mark-cache.sh
# For information about cache directory tags, see:
# http://www.brynosaurus.com/cachedir/
"

echo "$TEXT" > $1/CACHEDIR.TAG
