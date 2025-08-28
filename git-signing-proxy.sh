#!/bin/sh
# Signing proxy script for use with git + ssh signing
#
# When attempting to sign a commit/tag/etc., git will check with the SSH agent to see if the
# relevant key has been loaded. If the key is not present in the SSH agent, git will ask for the
# password for the key, but will *not* add it to the agent for future use. This can be inconvenient
# when doing large numbers of signing operations, eg. during a git rebase.
#
# This script addresses that issue by wrapping the git signing process and automatically loading the
# requested key into the SSH agent. All you need to do is set git's `gpg.ssh.program` configuration
# variable to point to this script.
#
# Note: This script only needs to be deployed on machines where the private key is available to be
# loaded. For purely remote machines, one valid setup is to store only the public key, and use SSH
# agent forwarding to provide access to the private key. In that case, you don't need to deploy
# this script to the remote machine - just point the `user.signingKey` config value at the public
# key file. If doing this, it is recommended that you store your private key on a security token
# and require tap-to-sign.
#
# To allow easier configuration, this script allows `user.signingKey` to be pointed at either the
# public or private key file. This way, that variable can be pointed at your public key across all
# machines, whether they have the private key file available or not. Similarly, installing this
# script on a machine which doesn't have your private key file won't cause problems, it just won't
# do anything.
#
#
#
# Originally written by Reddit user /u/jthill
# (https://old.reddit.com/r/git/comments/1coropv/is_there_a_way_to_add_ssh_key_to_sshagent_when/)
# and updated by Rachel Barker (https://rachelplusplus.me.uk/)
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

# Lifetime for loaded keys
KEY_LIFETIME=16h

IS_SIGNING=0

while getopts :Y:n:f: opt; do case $opt in
  # Only load keys if we see a `-Y sign` action.
  # Git will also invoke this script with other actions, such as `-Y verify` and `-Y find-principals`
  # during signature verification. These don't need a private key, and `-f` may point to something
  # else (such as an allowed_signers list), so in these cases we need to simply ignore the -f option.
  Y) if [ "$OPTARG" = "sign" ]; then IS_SIGNING=1; fi ;;

  f) if [ "$IS_SIGNING" -eq "1" ] && ! ssh-add -T "$OPTARG" 2>&-; then
      # Note: ssh-keygen can take either the public or private key file, but ssh-add must
      # be pointed at the private key - so fix that up here
      ssh-add -t "$KEY_LIFETIME" "${OPTARG%.pub}";
     fi ;;
esac; done

exec ssh-keygen "$@"
