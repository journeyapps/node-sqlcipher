var bindings = require('bindings');
var fs = require('fs');
var path = require('path');
var pkg = require('../package.json');

function getLocalBuildPath() {
    return path.join(__dirname, '..', 'build', 'Release', 'node_sqlite3.node');
}

function getPrebuiltPath() {
    var napiVersion = Number(process.versions.napi || 0);
    var versions = (((pkg.binary || {}).napi_versions) || [])
        .filter(function(version) {
            return version <= napiVersion;
        })
        .sort(function(a, b) {
            return b - a;
        });

    if (!versions.length) {
        return null;
    }

    return path.join(
        __dirname,
        'binding',
        'napi-v' + versions[0] + '-' + process.platform + '-' + process.arch,
        'node_sqlite3.node'
    );
}

function loadBinding() {
    var localBuildPath = getLocalBuildPath();
    var bindingPath = getPrebuiltPath();
    var localBuildError;
    var prebuiltError;

    if (fs.existsSync(localBuildPath)) {
        try {
            return require(localBuildPath);
        } catch (err) {
            localBuildError = err;
        }
    }

    if (bindingPath) {
        try {
            return require(bindingPath);
        } catch (err) {
            prebuiltError = err;
        }
    }

    try {
        return bindings('node_sqlite3.node');
    } catch (err) {
        if (localBuildError) {
            err.message += '\nFailed to load local build addon from ' + localBuildPath + ': ' + localBuildError.message;
        }
        if (prebuiltError) {
            err.message += '\nFailed to load prebuilt addon from ' + bindingPath + ': ' + prebuiltError.message;
        }
        throw err;
    }
}

module.exports = exports = loadBinding();
