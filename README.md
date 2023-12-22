# AutoProof
This repository is based on EiffelStudio with AutoProof extensions.

## Dependencies
AutoProof is known to work with:
* **Boogie** v2.11.1
* **Z3** 4.8.8
  * Z3 version should be compatible with Boogie.
    For now we recommend to use the version which is used in Boogie's test workflows
    https://github.com/boogie-org/boogie/blob/master/.github/workflows/test.yml#L14

## Tests
There are automated tests for AutoProof
located in `research/extension/autoproof/framework/eiffel2boogie/tests`.
Check that [directory's README](/research/extension/autoproof/framework/eiffel2boogie/tests/README.md)
for details on how to write and run tests.

Tests are also executed in CI, so you can check the workflow files for examples
of running tests.
