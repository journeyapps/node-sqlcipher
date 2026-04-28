# Including SQLCipher

**Note:** All these steps have already been performed in this repository. This is just for reference to e.g. change the SQLCipher version.

## Step 1: Get the SQLCipher source

Start from an official SQLCipher release tarball or a release tag, then build the amalgamation source.

```
curl -L https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.14.0.tar.gz -o sqlcipher.tar.gz
tar xf sqlcipher.tar.gz
cd sqlcipher-4.14.0
./configure --enable-all --disable-tcl
make sqlite3.c
```

The build produces the files we vendor in `deps/sqlcipher-amalgamation`:

```
sqlite3.c
sqlite3.h
shell.c
sqlite3ext.h
VERSION # rename to VERSION.txt
```

Copy these files into `deps/sqlcipher-amalgamation`, renaming `VERSION` to `VERSION.txt`.

## Step 2: OpenSSL provider

macOS no longer vendors OpenSSL in this repository. It uses SQLCipher's CommonCrypto provider through `Security.framework`.

Linux links against the system `libcrypto`.

Windows is not supported in this phase.

## Step 3: Test the build

Run:

```sh
pnpm exec node-gyp rebuild
```

Then run the tests:

```sh
pnpm test
```

If you want to verify the install path used by the published package, run `pnpm install` in a clean checkout and then rerun the tests.


# Notes

This repository now builds SQLCipher with:

* `SQLITE_HAS_CODEC`
* `SQLITE_EXTRA_INIT=sqlcipher_extra_init`
* `SQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown`
* `SQLITE_TEMP_STORE=2`

`deps/sqlite3.gyp` has been modified from the original node-sqlite3 one to:
 * Use CommonCrypto on macOS.
 * Link against system `libcrypto` on Linux.
 * Add additional define statements required by SQLCipher.
