---
layout: page
title: Reif installation
---
# Reif installation
This page describes the process of compilation and installation of Reif.
The installation includes AutoProof, AutoFix and all the other projects
of the Reif project.

Command examples are mainly written in `sh` style. Be aware if you are on Windows.

## Installing dependencies

There are several tools needed to compile and run Reif.

### The usual build essentials
Installation instructions depend on commonly used tools:
* `git`

### EiffelStudio
To compile Reif you need *EiffelStudio 24.05*. Download the release
from the [releases page](https://account.eiffel.com/downloads) and follow
the [EiffelStudio installation instructions](https://www.eiffel.org/doc/eiffelstudio/Software_Installation_for_EiffelStudio).

Take note of the `ISE_EIFFEL` environment variable. Next steps of
the installation use this variable.

### Boogie
To run AutoProof and features depending on static verification you need
to install *Boogie v2.11.1*. Releases and source code can
be downloaded from [the official Boogie repository](https://github.com/boogie-org/boogie).

To compile this version of Boogie from the source code you need to install
*.NET SDK 6.0*. You can find downloads and installation instructions
on [the official page](https://dotnet.microsoft.com/en-us/download/dotnet/6.0).

To download and compile the correct version of Boogie execute the following:
```bash
git clone https://github.com/boogie-org/boogie.git
cd boogie
git checkout v2.11.1
dotnet build Source/Boogie.sln
```

Boogie files must be installed into the EiffelStudio folder. Copy the contents
of the`Source/BoogieDriver/bin/Debug/net6.0` folder to a new folder
`$ISE_EIFFEL/studio/tools/boogie`. Also, rename the Boogie executable `BoogieDriver`
to `boogie`. The commands for the both steps:
```bash
cp -rp Source/BoogieDriver/bin/Debug/net6.0/* $ISE_EIFFEL/studio/tools/boogie/
mv $ISE_EIFFEL/studio/tools/boogie/BoogieDriver $ISE_EIFFEL/studio/tools/boogie/boogie
```

Boogie requires Z3, so do not skip the installation instructions for Z3.

### Z3
To use AutoProof you need to install *Z3 4.8.8*. Releases and source code
can be obtained from [the official Z3 repository](https://github.com/Z3Prover/z3).

After installing Z3 make sure that `z3` is available in `$PATH`.

## Compiling Reif
After installing the dependencies you are ready to compile Reif.

### Getting the Reif source code
The full source code of Reif is available in
[the Reif repository](https://github.com/CI-CSE/reif).

Note that the default branch name is `research`,
not `master` (which is the normal EiffelStudio code).

To download the code using git:
```bash
git clone git@github.com:CI-CSE/reif.git
```

### Setting environment variables
Several tools in Reif depend on the `$AP` environment variable. It must
be set to the `research/extensions/autoproof` folder in the Reif source code.

```bash
export AP=~/reif/research/extension/autoproof
```

### Installation of AutoProof support files
Make a symbolic link from `$ISE_EIFFEL/studio/tools/autoproof` to the `$AP` folder.
```bash
ln -s $AP $ISE_EIFFEL/studio/tools/autoproof
```

Symbolic link makes it easier to update files when working with different
versions of the Reif source code. If you do not plan to switch versions
using git, you can simply copy the `$AP` folder
with a new path `$ISE_EIFFEL/studio/tools/autoproof`.

### Compiling platform-dependent libraries
Reif contains some libraries (inherited from EiffelStudio)
which must be compiled manually. The compilation scripts for Linux and
Windows are in the `research` folder.

* If you are on Linux, run `research/compile_c.sh`
* If you are on Windows, run `research/compile_c.bat`

### Compiling Reif
The main Reif project file is `research/extension/autoproof/autoproof.ecf`.
It contains two targets. Choose the target depending on your needs:
* `bench` is the main Reif version which includes the graphical interface.
* `batch` is the smaller version which includes only the command-line interface.

You can open the project file in EiffelStudio or simply compile it
using the command line version.

For example, we can compile the release (finalized) version with GUI:
```bash
ec -config reif/research/autoproof/autoproof.ecf -target bench -finalize -c_compile -batch
```

### Running Reif
Run the compiled executable which was produced in the previous step.

To quickly test autoproof verification, you can try to verify an example class:
```bash
EIFGENs/bench/F_code/autoproof -config $AP/library/base/base-scoop-safe.ecf -autoproof $AP/library/base/base2/dispenser/v_linked_queue.e
```

You should see the verification output.
