#!/bin/sh

GIT_CMD="$(command -v git)"
if ! [ -x $GIT_CMD ]; then
    echo 'Error: git is not installed.' >&2
    exit 1
fi

# Install the profile files
$GIT_CMD clone https://github.com/pixnyb/profiles.git $HOME/.profiles 1>/dev/null 2>&1
RES=$?
if [ $RES -ne 0 ]; then
    echo 'Error: failed to clone the repository.' >&2
    exit 1
fi

$WORKDIR=$PWD
cd $HOME/.profiles
./load.sh

# Remove the cloned repository
cd $WORKDIR
rm -rf $HOME/.profiles

echo 'Profile files for the appropriate shells have been installed, please restart your shell.'
