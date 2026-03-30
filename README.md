Fork of [node-sqlite3](https://github.com/mapbox/node-sqlite3), modified to use [SQLCipher](https://www.zetetic.net/sqlcipher/).

This fork bundles SQLCipher directly and now supports rebuilding from source again when no matching prebuilt binary is available.

## Supported platforms

Published binaries are built against N-API 6.

Older N-API 3 binaries are no longer published.

If no matching binary is available for your platform or runtime, the published package includes the native sources needed to rebuild from source on macOS and Linux.

# Installation

```sh
pnpm add "@journeyapps/sqlcipher"
# Or: npm install --save "@journeyapps/sqlcipher"
```

## Development

This repository uses `pnpm` for local development and CI.

The active CI matrix targets Node 24 and Electron 41.

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

## Building from source.

Building from source when installing the package is supported again.

The published tarball includes the native sources needed for macOS and Linux rebuilds so that `pnpm install`, `npm install`, `node-gyp rebuild`, and rebuild tools such as `@electron/rebuild` can compile the addon when needed.

Platform notes:

1. macOS uses SQLCipher's CommonCrypto provider via `Security.framework` and does not require Homebrew `openssl@1.1`.
2. Linux links against the system `libcrypto`.
3. Windows installs should use a matching prebuilt binary. The published npm tarball no longer includes the vendored Windows OpenSSL toolchain needed for source builds.

### Windows source builds

Windows source builds are still possible, but they now require a checkout of this repository instead of the published npm tarball.

From a Windows checkout of the repository:

1. Refresh the vendored OpenSSL 3 headers and static libraries:

   ```bat
   deps\openssl-windows.bat
   ```

2. Install dependencies and rebuild:

   ```bat
   pnpm install
   pnpm exec node-pre-gyp rebuild
   ```

This refresh populates `deps/OpenSSL-Win32`, `deps/OpenSSL-Win64`, `deps/OpenSSL-Win64-ARM`, and `deps/openssl-include`, which are required by the Windows build configuration.

## Usage with electron-forge / @electron/rebuild

[electron-forge](https://www.electronforge.io/) uses [@electron/rebuild](https://github.com/electron/rebuild) and will rebuild native modules from source by default.

That rebuild path is now supported by the published package. If a matching prebuilt binary exists you can still skip rebuilding this module to speed up install times, but it is no longer required as a workaround.

To skip rebuilding when a matching prebuilt binary is already present, disable rebuilding of this library using the `onlyModules` option of `@electron/rebuild` in your `package.json`:

        "config": {
            "forge": {
                "electronRebuildConfig": {
                    "onlyModules": []  // Specify other native modules here if required
                }
            }
        }

Note: [electron-builder](https://www.electron.build/) should continue to work directly.

## OpenSSL

SQLCipher depends on OpenSSL.

On macOS we use CommonCrypto instead of a vendored OpenSSL build.

On Linux we dynamically link against the system OpenSSL / `libcrypto`.

For repository-based Windows builds we keep static OpenSSL artifacts in `deps/`. These can be refreshed with [vcpkg](https://github.com/microsoft/vcpkg) via `deps/openssl-windows.bat`.

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
