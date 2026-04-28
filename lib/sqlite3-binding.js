var bindings = require('bindings');
var fs = require('fs');
var path = require('path');

function getLocalBuildPath() {
    return path.join(__dirname, '..', 'build', 'Release', 'node_sqlite3.node');
}

function loadBinding() {
    var localBuildPath = getLocalBuildPath();
    var localBuildError;

    if (fs.existsSync(localBuildPath)) {
        try {
            return require(localBuildPath);
        } catch (err) {
            localBuildError = err;
        }
    }

    try {
        return bindings('node_sqlite3.node');
    } catch (err) {
        if (localBuildError) {
            err.message += '\nFailed to load local build addon from ' + localBuildPath + ': ' + localBuildError.message;
        }
        throw err;
    }
}

module.exports = exports = loadBinding();
