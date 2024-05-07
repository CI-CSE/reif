# AutoProof automated tests

This directory contains automated tests for AutoProof.

To execute tests run:
```shell
python runtests.py --dir examples
```

The script takes several command line options. To see which are supported run:
```shell
python runtests.py -h
```

After running tests, the last line of the output contains the testing results.
It shows the number of classes which had the expected/unexpected verification results:
```python
{'passed': 11, 'failed': 34, 'error': 0}
```

## The `examples` and `legacy` folders
Tests in `examples` must pass. This is the place for new tests.

Tests in `legacy` must fail. This is place for old tests.
**Don't add tests to `legacy`!**

> [!CAUTION]
> Don't add tests to `legacy` folder. Add new tests to `examples`.
> Fixed tests from `legacy` must be moved to `examples`.

> [!IMPORTANT]
> The CI checks that all tests in `examples` pass (as usual)
> and checks that no tests pass in `legacy` pass (if they pass,
> they should move to `examples`

## Test structure
Tests are Eiffel classes located in *test directories*. They should be included in the `tests.ecf` file i.e.
they should belong to a cluster.

*Test directory* is a directory which has `output.txt`. The file `output.txt` must contain
the expected output of AutoProof's verification of the classes in the *test directory*.

Classes are passed as command line parameters to `ec -autoproof` in ascending sorted order
based on the `*.e` filenames in the directory. For example, having `b.e`, ``a.e`, `a2.e`
files in directory will trigger `ec -autoproof A A1 B`. This can be important for the order
of the output of AutoProof. However, it is easier to simply have one class in one test directory
to avoid dealing with this order at all.

### How to add a test

1. Create a subdirectory of any depth in [tests](/research/extension/autoproof/framework/eiffel2boogie/tests).
2. Move the file of the test class in the newly created directory.
3. Run the command line version of AutoProof on the test class and save the text output after "System recompile." in a `output.txt` file.
4. Move the `output.txt` file from step 3 in the directory created in step 1.
5. Ensure that the test class is in the system (add a cluster in `tests.ecf` if needed)

To run just the added test, pass the name of the newly created directory as the last parameter to the script.

For example, we add a new test. The test class is located in `new_tests/test1/test_class.e`.
Output file should be located at `new_tests/test1/output.txt`. This test can be ran with:
```shell
python runtests.py test1
```

Note that we pass just `test1`, not `new_tests/test1` nor `new_tests/test1/test_class.e`.
