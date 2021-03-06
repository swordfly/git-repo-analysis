#!/usr/bin/env bash
#
# git-find-dirs-unwanted.sh
#
# Search the entire history of a Git repository for (potentially)
# unwanted directories. E.g. 3rd party directories, temp, build or
# Perforce stream directories.
#
# The script prints the number of files under each directory to see the
# impact on the Git tree. Directories with a large number of files can
# be good candidates for exclusions in repository migrations to Git.
#
# The script must be called in the Git root directory.
#
# Author: Lars Schneider, http://larsxschneider.github.io/
#

DIRS=$(git log --all --name-only --pretty=format: \
    | awk -F'[^/]*$' '{print $1}' \
    | sort -u \
    | grep -i \
        -e 3p \
        -e 3rd \
        -e artifacts \
        -e assemblies \
        -e backup \
        -e bin \
        -e build \
        -e components \
        -e debug \
        -e deploy \
        -e generated \
        -e install \
        -e lib \
        -e modules \
        -e obj \
        -e output \
        -e packages \
        -e party \
        -e recycle.bin \
        -e release \
        -e resources \
        -e streams \
        -e temp \
        -e third \
        -e tmp \
        -e tools \
        -e util \
        -e vendor \
        -e x64 \
        -e x86 \
)

IFS=$'\n'
for I in $DIRS; do
    if [ -e "$I" ]; then
        FILE_COUNT=$(find "$I" -type f | wc -l)
        echo "$FILE_COUNT $I"
    else
        while ! [ -e $(dirname "$I") ]; do
            I=$(dirname "$I")/;
        done;
        echo "deleted  $I"
    fi
done | sort -n -r | uniq
