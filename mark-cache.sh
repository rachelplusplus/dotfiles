#!/bin/bash
# Mark a directory as a "cache", which tells most backup tools to ignore it
#
# Originally written by Rachel Barker (https://rachelplusplus.me.uk/)
#
# Licensed under the BSD 0-Clause license:
#
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without
# fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
# SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
# OF THIS SOFTWARE.

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
# This file is a cache directory tag
# For information about cache directory tags, see:
#	http://www.brynosaurus.com/cachedir/
"

echo "$TEXT" > $1/CACHEDIR.TAG
