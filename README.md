Fork of [node-sqlite3](https://github.com/mapbox/node-sqlite3), modified to use [SQLCipher](https://www.zetetic.net/sqlcipher/).

This fork bundles SQLCipher directly and currently ships as a source-build-only package for macOS and Linux.

## Supported platforms

- macOS
- Linux

Windows and prebuilt binary publishing are intentionally unsupported in this phase.

# Installation

```sh
pnpm add "@journeyapps/sqlcipher"
# Or: npm install --save "@journeyapps/sqlcipher"
```

The install script always builds the native addon from source.

On Linux you will need the standard native toolchain plus OpenSSL development headers, for example:

```sh
sudo apt-get install -y build-essential libssl-dev pkg-config
```

## Development

This repository uses `pnpm` for local development and CI on macOS and Linux.

The active CI matrix targets Node 24 and Electron 41 on the supported platforms.

Use `nvm use` to match the checked-in Node version from `.nvmrc` when working locally.

```sh
pnpm install
pnpm test
```

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

A copy of the source for SQLCipher 4.14.0 is bundled, which is based on SQLite 3.51.3.

## Building from source

Building from source is the only supported install path in this phase.

The published tarball includes the native sources needed for macOS and Linux rebuilds so that `pnpm install`, `npm install`, `node-gyp rebuild`, and rebuild tools such as `@electron/rebuild` can compile the addon when needed.

Platform notes:

1. macOS uses SQLCipher's CommonCrypto provider via `Security.framework` and does not require Homebrew `openssl@1.1`.
2. Linux links against the system `libcrypto`.
3. Windows is not supported.

## Usage with electron-forge / @electron/rebuild

[electron-forge](https://www.electronforge.io/) uses [@electron/rebuild](https://github.com/electron/rebuild) and will rebuild native modules from source by default.

That rebuild path is the expected install path for this package.

To ensure this library is rebuilt along with the rest of your native dependencies, keep it included in your `@electron/rebuild` configuration:

        "config": {
            "forge": {
                "electronRebuildConfig": {
                    "onlyModules": ["@journeyapps/sqlcipher"]
                }
            }
        }

Note: [electron-builder](https://www.electron.build/) should continue to work directly.

## OpenSSL

SQLCipher depends on OpenSSL.

On macOS we use CommonCrypto instead of a vendored OpenSSL build.

On Linux we dynamically link against the system OpenSSL / `libcrypto`.

Windows is not supported in this phase.

# API

See the [API documentation](https://github.com/mapbox/node-sqlite3/wiki) in the wiki.

Documentation for the SQLCipher extension is available [here](https://www.zetetic.net/sqlcipher/sqlcipher-api/).

# Acknowledgments

Most of the work in this library is from the [node-sqlite3](https://github.com/mapbox/node-sqlite3) library by [MapBox](https://mapbox.com/).

Additionally, some of the SQLCipher-related changes are based on a fork by [liubiggun](https://github.com/liubiggun/node-sqlite3).

# License

`node-sqlcipher` is [BSD licensed](./LICENSE).

`SQLCipher` is `Copyright (c) 2016, ZETETIC LLC` under the [BSD license](https://github.com/sqlcipher/sqlcipher/blob/master/LICENSE).

`SQLite` is Public Domain
