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


# Code Guidlines
🙌 **Thanks for contributing**

Please follow these guidelines when submitting code.

## General rules:
- 🚫 Don't push on main
	1. 🌿 Create a branch
	2. ↩️ Make a pull request
- 📏Branches follow a [naming convention] (#pull-requests-pr)
- 📜Merging is done by a [protocol](#Merging)

### Requirements
1. No dead code🧟
	- No commented out code
	- No code which was never used
2. Non-obvious features have a descriptive [comment](#Comments) ✒️
3. Variable names are descriptive 💇
	- no `foo`, `bar` but `is_first_reachable`
	- no `n1`, `n2` but `ancestor`, `child`
	- no `i`, `j`, `k` but `row`, `column`
4. Meaningful contracts are present📄 (checks and postconditions are often good documentation)
5. Feature length < 100 LOC 📏 (This is not a hard requirement, but often you should refactor the feature if it becomes too long)
6. Resolve `ToDo` comments when possible ⚠️
7. `ToDo` comments are precise enough that anyone can understand it to fix it later. ⚠️✨
8. Add tests for your feature if their function is not trivial 👷 (tests are good documentation)
9. Improve decoupling 🪓 (If you can meaningfully split a feature into two → do it)
10. Add subclusters to give structure to classes 👨👶
### Comments
These rules are heavily inspired from the [stackoverflow.blog](https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/)
1. Good code is better than comments.
2. Comments should not duplicate the code.
3. Good comments do not excuse unclear code.
4. If you can't write a clear comment, there may be a problem with the code.
5. Comments should dispel confusion, not cause it.
6. Explain unidiomatic code in comments.
7. Provide links to the original source of copied code.
8. Include links to external references where they will be most helpful.
9. Add comments when doing workarounds.
10. Use comments to mark incomplete implementations.

## Pull Requests [PR]
### Naming:
$\{Category\}-\{Name\}$</br>
where</br>
$Category \in \{Fix, Exp, Feat, Ref\}$</br>
$Name$ is free-text

### Fix 🪲
PR **fixing** a problem in the code.
- It does not change the behavior of the rest of the code.
### Ref 🔀
PR **refactoring** parts of the code.
- don't change the behavior of the code.
	- Functional tests should behave the same before and after
	- Clients of the libraries should not notice a change
- reorganize some code
- add comments
- fuse or split {classes, functions, procedures, attributes}
- improve performance
### Feat ✨
PR introducing a new **feature**.
- Functionality which was not present before is now present.
### Exp 🧪
PR introducing a new **experimental** feature which is characterized by the follwoing:
- Functionality which was not present before is now present.
- You don't have time or are willing to comply to the code quality standards.
- You don't put thought into how to integrate the features meaningfully in the code base.

## Commits
🚀 Commits can almost always be improved. </br>
😇🪽 Try to reach the highest stage described in the following.</br>
☝️ Stage 0 is mandatory.
### Stage 0
- Nice language (repos might get public at some point)
	- 🚫 No cursing
	- 🚫 No insults
### Stage 1
- Commit messages are meaningful: 
  - 🚫 no: "fix", "debug", ".", "refactor"
  - ✅ "split feature `do_everything` into `aggregate`, `transform`, `output`"
  - ✅ "fix typo in contract in class `MML_SEQUENCE`"
### Stage 2
- Commit size is appropriate.
	- 🚫 Don't put all 1000 LOC in one commit.
### Stage 3
There is no stage 3. Don't be fancy.
## Code Quality
In general: 
> _Leave the code you touched nicer then you have seen it._

The following are hard requirements from now on to get a branch merged into main. </br>
⚠️ Therefore are mandatory for the PR of type Fix🪲, Feat✨, Ref🔀.</br>
➡️ They are encouraged for branches of type Exp 🧪 if it should be merged in the future.

## Merging
### Merge Conflicts
Merge conflicts are bound to happen.</br>
They should be resolved on the merging branch and not the target. (rebase main into your branch to resolve merge conflicts)
### Merge Review

| Type of PR | Number of approvals |
| ---- | ---- |
| Fix 🪲 | 1 |
| Ref 🔀, Feat ✨ | 2 |
| External PR, Exp 🧪 | 3 |

#### Reviewer duties
The reviewer ...</br>
... checks a MR for [code quality](#Requirements).</br>
... does a smoke test of the branch (Checks if the code runs and the features are callable)
### External PR
#### TODO: When external contribute we need to make them transfer copy right to us.
