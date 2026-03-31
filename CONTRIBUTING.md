# Contributing

General guidelines for contributing to node-sqlcipher.

# Testing

[mocha](https://github.com/visionmedia/mocha) is required to run unit tests.

In sqlite3's directory (where its `package.json` resides) run the following:

    pnpm install
    pnpm test

## Developing / Pre-release

Create a milestone for the next release on github. If all anticipated changes are back compatible then a `patch` release is in order. If minor API changes are needed then a `minor` release is in order. And a `major` bump is warranted if major API changes are needed.

Assign tickets and pull requests you are working to the milestone you created.

Create a changeset for any change that should result in a published package version:

```sh
pnpm changeset
```

## Releasing

To release a new version:

**1)** Ensure tests are passing

Before considering a release all the tests need to be passing in the `Test` and `Release` GitHub Actions workflows.

**2)** Bump commit

Bump the version in `package.json` like https://github.com/mapbox/node-sqlite3/commit/77d51d5785b047ff40f6a8225051488a0d96f7fd

**7)** Officially release

An official release requires:

 - Updating the CHANGELOG.md
 - Create and push github tag like `git tag v3.1.1 -m "v3.1.1" && git push --tags`
 - Ensure you have a clean checkout (no extra files in your check that are not known by git). You need to be careful, for instance, to avoid a large accidental file being packaged by npm. You can get a view of what npm will publish by running `make testpack`
 - Fully rebuild and ensure install from source works: `make clean && pnpm install --frozen-lockfile`
 - Then publish the module to npm repositories by running `npm publish`
