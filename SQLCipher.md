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

Run the following commands to generate the latest OpenSSL libs for Windows:

```
cd deps
.\openssl-windows.bat
```

... this will output the libs in `deps/openssl-windows` (OpenSSL-WinXX), including the header files in `deps/openssl-windows/openssl-include`. Every arch-specific folder includes these binaries:

```
libcrypto.lib
libssl.lib
ossl_static.pdb
```

Copy all folders under `deps/openssl-windows` to `sqlcipher-amalgamation-<version>`.

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

The OpenSSL files are specifically required for Electron, which doesn't bundle OpenSSL like NodeJS does. The header and .lib files are required at compile-time. We bundle a statically-linked version of OpenSSL with the library, so the user does not need to manually install OpenSSL.

`deps/sqlite3.gyp` has been modified from the original node-sqlite3 one to:
 * Use the bundled OpenSSL on Windows.
 * Add additional define statements required by SQLCipher.


