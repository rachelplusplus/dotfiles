#!/bin/sh
# Signing proxy script for use with git + ssh signing
#
# This script works around an issue where git does not load keys into the SSH agent - meaning that
# you get asked for your password every time you sign something. This script sits in the middle
# and automatically loads your key into the ssh agent when necessary, so that you only have to
# type your password once.
#
# This script should be deployed on any machine where you use git locally. For remote usage over
# SSH, if you use SSH agent forwarding then it's preferable to use the same key for login and
# signing so that it will already be in your SSH agent when needed. That way, you can avoid storing
# your private key file, even encrypted, on those remote machines.
#
# To support this use case, this script allows the key to use to be specified as path to a public
# key file. The private key path will be automatically derviced from this when needed. That way,
# you can point git's user.signingKey config variable to your public key on all machines,
# regardless of whether you use them locally (so have the private key available) or remotely
# (so don't have the private key available).
#
# Based heavily on
# https://old.reddit.com/r/git/comments/1coropv/is_there_a_way_to_add_ssh_key_to_sshagent_when/

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
      ssh-add -t "$KEY_LIFETIME" "${OPTARG%.pub}";
     fi ;;
esac; done

exec ssh-keygen "$@"
