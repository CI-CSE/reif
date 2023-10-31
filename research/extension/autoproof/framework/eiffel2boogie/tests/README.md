# AutoProof automated tests

This directory contains automated tests for AutoProof.

To execute tests run:
```shell
python runtests.py
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
1. Make directory for the test (can be a subdirectory of any depth)
2. Put the `*.e` file in the directory
3. Put the `output.txt` file in the directory
4. Make sure that the class is in the system (add a cluster to `tests.ecf` if needed)
5. To run just the added test, pass the name of the directory as the last parameter to the script

For example, we add a new test. The test class is located in `new_tests/test1/test_class.e`.
Output file should be located at `new_tests/test1/output.txt`. This test can be ran with:
```shell
python runtests.py test1
```

Note that we pass just `test1`, not `new_tests/test1` nor `new_tests/test1/test_class.e`.
