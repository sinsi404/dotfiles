#!/bin/bash

DIR=`pwd -P`
for name in .??*
do
    [[ "${name}" == ".git" ]] && continue
    [[ "${name}" == ".DS_Store" ]] && continue

    ln -s ${DIR}/${name} ~/${name}
done
