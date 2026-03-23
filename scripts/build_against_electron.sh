#!/usr/bin/env bash

source ~/.nvm/nvm.sh

set -e -u

export DISPLAY=":99.0"
GYP_ARGS="--runtime=electron --target=${ELECTRON_VERSION} --dist-url=https://electronjs.org/headers"

function publish() {
    if [[ ${PUBLISHABLE:-false} == true ]] && [[ ${COMMIT_MESSAGE} =~ "[publish binary]" ]]; then
        pnpm exec node-pre-gyp package $GYP_ARGS
        pnpm exec node-pre-gyp publish $GYP_ARGS
        pnpm exec node-pre-gyp info $GYP_ARGS
    fi
}

function electron_pretest() {
    pnpm add --save-dev electron@${ELECTRON_VERSION}
    if [ "${TRAVIS_OS_NAME}" = "osx" ]; then 
        (sudo Xvfb :99 -ac -screen 0 1024x768x8; echo ok )&
    else
        sh -e /etc/init.d/xvfb start 
    fi

    sleep 3
}

function electron_test() {
    pnpm exec electron test/support/createdb-electron.js
    pnpm exec electron-mocha -R spec --timeout 480000
}

# test installing from source
npm_config_build_from_source=true npm_config_clang=1 npm_config_runtime=electron npm_config_target=${ELECTRON_VERSION} npm_config_disturl=https://electronjs.org/headers pnpm install

electron_pretest
electron_test

publish
make clean

# now test building against shared sqlite
export NODE_SQLITE3_JSON1=no
if [[ $(uname -s) == 'Darwin' ]]; then
    brew update
    brew install sqlite
    npm_config_build_from_source=true npm_config_sqlite=$(brew --prefix) npm_config_clang=1 npm_config_runtime=electron npm_config_target=${ELECTRON_VERSION} npm_config_disturl=https://electronjs.org/headers pnpm install
else
    npm_config_build_from_source=true npm_config_sqlite=/usr npm_config_clang=1 npm_config_runtime=electron npm_config_target=${ELECTRON_VERSION} npm_config_disturl=https://electronjs.org/headers pnpm install
fi
electron_test
export NODE_SQLITE3_JSON1=yes
