# Including SQLCipher

**Note:** All these steps have already been performed in this repository. This is just for reference to e.g. change the SQLCipher version.

## Step 1: Get the SQLCipher source

Clone the sqlcipher repo, and build the amalgamation source.

```
git clone git@github.com:sqlcipher/sqlcipher.git
cd sqlcipher
./configure
make sqlite3.c

VERSION=3031000
mkdir sqlcipher-amalgamation-$VERSION
cp sqlite3.c sqlite3.h shell.c sqlite3ext.h VERSION sqlcipher-amalgamation-$VERSION/
```

The above produces 4 files of interest:

```
sqlite3.c
sqlite3.h
shell.c # optional
sqlite3ext.h # optional
VERSION # optional
```

The files are copied to: `sqlcipher-amalgamation-<version>`.

## Step 2: Get OpenSSL libraries

NodeJS typically includes OpenSSL. However, for Electron on Windows, we need to bundle a copy.

Download OpenSSL 1.0.x from https://slproweb.com/products/Win32OpenSSL.html, both 32-bit and 64-bit versions. Install locally, then copy these files:

```
lib/libeay32.lib
lib/ssleay32.lib
bin/libeay32.dll
bin/msvcr120.dll
```

Place these files in `sqlcipher-amalgamation-<version>/OpenSSL-Win32` and `sqlcipher-amalgamation-<version>/OpenSSL-Win64`.

Copy the header files (include folder) to `sqlcipher-amalgamation-<version>/openssl-include/openssl`.

## Step 3: Build the archive

Archive the folder as `deps/sqlcipher-amalgamation-<version>.tar.gz`, and update the version number in `common-sqlite.gypi` (must be the same).

```
tar czf sqlcipher-amalgamation-$VERSION.tar.gz sqlcipher-amalgamation-$VERSION
```

## Step 4: Test the build

Run:

```sh
./node_modules/.bin/node-pre-gyp install --build-from-source
```

Then run the tests:

```sh
npm run test
```


# Notes

The OpenSSL files are specifically required for Electron, which doesn't bundle OpenSSL like NodeJS does. The header and .lib files are required at compile-time, and `libeay32.dll` and `mscvr120.dll` are required at runtime. We bundle it with the library, so the user does not need to manually install OpenSSL.

`deps/sqlite3.gyp` has been modified from the original node-sqlite3 one to:
 * Use the bundled OpenSSL on Windows.
 * Add additional define statements required by SQLCipher.


