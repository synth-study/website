#!/bin/bash

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

[[ $(git status --porcelain) = "" ]] || {
	echo "Uncommitted changes! Quitting." >&2
	exit 1
}

old_branch=$(git branch --show-current)

git checkout main # >/dev/null 2>/dev/null

while read f ; do
    git restore --source dev "${f}"
done < <(git ls-tree --full-tree -r --name-only dev | ag '\.(css|html|ico|js|png|xml)$' | ag -v '\.raw.html$')

git add .

{
    git commit -m "Latest site $(date)"
} || {
    echo "Nothing to do!"
    git checkout "${old_branch}"
    exit 0
}

{
    git push
} || {
    echo "Nothing to do!"
    git checkout "${old_branch}"
    exit 0
}

git checkout "${old_branch}"
