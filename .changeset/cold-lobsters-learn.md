---
"@journeyapps/sqlcipher": major
---

Drop Windows support and switch the package to source-build-only installs on macOS and Linux. Remove `node-pre-gyp`, prebuilt binary publishing, and the vendored Windows OpenSSL toolchain from the repository for this phase.
