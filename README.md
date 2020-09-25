Fork of [node-sqlite3](https://github.com/mapbox/node-sqlite3), modified to use [SQLCipher](https://www.zetetic.net/sqlcipher/).

While the `node-sqlite3` project does include support for compiling against sqlcipher, it requires manual work, and does not work out-of-the-box on Electron on Windows. This fork changes the default configuration to bundle SQLCipher directly, as well as OpenSSL where required.

## Supported platforms

Binaries are built against N-API 3 and 6, on MacOS, Windows (ia32 and x64) and Linux (x64).

Node 10+ and Electron 6+ is supported.

Other platforms/architectures may work by building from source - see the section below.

# Installation

```sh
yarn add "@journeyapps/sqlcipher"
# Or: npm install --save "@journeyapps/sqlcipher"
```

For Electron, use `electron-rebuild` or similar tool.

# Usage

``` js
var sqlite3 = require('@journeyapps/sqlcipher').verbose();
var db = new sqlite3.Database('test.db');

db.serialize(function() {
  // This is the default, but it is good to specify explicitly:
  db.run("PRAGMA cipher_compatibility = 4");

  // To open a database created with SQLCipher 3.x, use this:
  // db.run("PRAGMA cipher_compatibility = 3");

  db.run("PRAGMA key = 'mysecret'");
  db.run("CREATE TABLE lorem (info TEXT)");

  var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
  for (var i = 0; i < 10; i++) {
      stmt.run("Ipsum " + i);
  }
  stmt.finalize();

  db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
      console.log(row.id + ": " + row.info);
  });
});

db.close();
```

# SQLCipher

A copy of the source for SQLCipher 4.4.0 is bundled, which is based on SQLite 3.31.0.

## Building from source.

This is done automatically by node-pre-gyp when installing on a platform without pre-built binaries.
However, this does require some additional setup, and is likely to run against obscure errors when installing.

Requirements:

### Mac

 * `brew install openssl@1.1`

### Windows

 * Visual Studio 2015
 * Python 2.7

## OpenSSL

SQLCipher depends on OpenSSL. When using NodeJS, OpenSSL is provided by NodeJS itself. For Electron, we need to use our own copy.

For Windows, we bundle OpenSSL 1.0.2n. Pre-built libraries are used from https://slproweb.com/products/Win32OpenSSL.html.

On Mac we build against OpenSSL installed via brew, but statically link it so that end-users do not need to install it.

On Linux we dynamically link against the system OpenSSL.

# API

See the [API documentation](https://github.com/mapbox/node-sqlite3/wiki) in the wiki.

Documentation for the SQLCipher extension is available [here](https://www.zetetic.net/sqlcipher/sqlcipher-api/).

# Testing

[mocha](https://github.com/visionmedia/mocha) is required to run unit tests.

In sqlite3's directory (where its `package.json` resides) run the following:

    npm install --build-from-source
    npm test

# Publishing

To publish a new version, run:

    npm version minor -m "%s [publish binary]"
    npm publish

Publishing of the prebuilt binaries is performed on CircleCI.

# Acknowledgments

Most of the work in this library is from the [node-sqlite3](https://github.com/mapbox/node-sqlite3) library by [MapBox](https://mapbox.com/).

Additionally, some of the SQLCipher-related changes are based on a fork by [liubiggun](https://github.com/liubiggun/node-sqlite3).

# License

`node-sqlcipher` is [BSD licensed](./LICENSE).

`SQLCipher` is `Copyright (c) 2016, ZETETIC LLC` under the [BSD license](https://github.com/sqlcipher/sqlcipher/blob/master/LICENSE).

`SQLite` is Public Domain
