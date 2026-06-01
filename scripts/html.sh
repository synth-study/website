#!/bin/bash

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

while read f ; do
    echo "${f}"
    d=$(dirname "${f}")
    b="${d}"/index.html
    if [[ ! -r "${b}" ]] ; then
        a="${d}"/$(basename "${f}")
        minify --type html --html-keep-document-tags --html-keep-end-tags "${a}" > "${b}"
    fi
done < <(find "${wd}" -name index.raw.html)
