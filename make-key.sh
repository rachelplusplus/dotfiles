#!/bin/bash
# Generate a random 256-bit key and write it securely to a file
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

case $# in
  0) OUTPUT=/dev/stdout ;;
  1) if [ "$1" = "-" ]; then
      OUTPUT=/dev/stdout
     else
      OUTPUT="$1"
     fi ;;
  *) echo "Usage: $0 [FILE]" > /dev/stderr
     echo "Creates a random 256-bit key and writes to FILE" > /dev/stderr
     echo "If FILE is not specified, or is set to '-', writes to stdout" > /dev/stderr
     exit 2 ;;
esac

# Make output readable only by the creating user
umask 0077
dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 > $OUTPUT
