# Overview
- The dockerfile builds an image that can run autoproof.
- It contains the sourcecode of EiffelStudio and the binary of autoproof. (As autoproof seems to rely on EiffelStudio code to be available)
- The dockerfile does a two step build.
  1. Compile autoproof (Based on Ubuntu)
  2. Copy compiled binary (Based on Alpine)

# Prerequisites
- Docker is preinstalled.
- Knowledge of Docker is helpful.

# TLDR
This setup was tested in the following way:

- The project folder was on a Windows system in the path: `C:\Users\JohnDoe\Code\Test_project`
- The libraries were then in `C:\Users\JohnDoe\Code\Eiffel_library`
- The project was opened and edited with a local version of `EiffelStudio23`
- The docker image was downloaded from `risajef/autoproof:0.0.2`
- To start the docker `docker run -it -v .\Test_project\:/Test_project risajef/autoproof:latest sh`
- Inside the container I verified the project using `/bin/apb -config /Test_project/project.ecf -batch -c_compile -autoproof`

# Building
At the moment the images are pushed to a personal docker repository on [dockerhub](https://hub.docker.com/repository/docker/risajef/autoproof/general).

First build the image and tag it appropriately.
```
docker build . -t risajef/autoproof:X.X.X
docker image tag risajef/autoproof:X.X.X risajef/autoproof:latest
```

# Running
```
docker run -it -v ./Test_project:/Test_project risajef/autoproof:latest sh
```
This will:
- download the image from docker hub
- start a container
- map your local folder `./Test_project` into `/Test_project`
- start a `sh` session

Inside the session you can now execute autproof
```
/bin/apb -config /Test_project/project.ecf -batch -c_compile -autoproof
```

Bacause how volumes work in docker you can read and write the files in the mapped folder from your host system and inside your docker environment.

So you can edit the files in your host system and proof the inside the docker.

If you want to do this you have to check that `EIFGENs` inside the docker image are not in conflict with the ones from your host system. Which is achieved by the command above which will generate `EIFGENs` in the (unshared) root folder and not inside the project folder.

# Extract library for host
Maybe the project you are trying to verify is using the base2 library. This library is also inside the docker container and can be mapped into your host system such that you can access it. For this create an instance that shares a folder:
```
docker run -it  -v ./Eiffel_library:/export risajef/autoproof:latest sh
```
And then inside the container copy the library folder into the export folder:
```
cp -R /library/ /export/
```
Set the environment variable `AP` on your host system such that it points to the folder you just exported the libraries into.
e.g. `export AP=/home/johndoe/Eiffel_library`

# Hello Autoproof
You can test the setup by using the following `project.ecf`:
```
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-23-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-23-0 http://www.eiffel.com/developers/xml/configuration-1-23-0.xsd" name="project" uuid="6CA2BCA8-E614-45A3-90B8-6D59E65EB3F0">
	<target name="project">
		<root all_classes="true"/>
		<capability>
			<void_safety support="none" use="none"/>
			<concurrency support="none" use="none"/>
		</capability>
		<file_rule>
			<exclude>/CVS$</exclude>
			<exclude>/EIFGENs$</exclude>
			<exclude>/\.git$</exclude>
			<exclude>/\.svn$</exclude>
		</file_rule>
		<option warning="warning" is_obsolete_iteration="true" manifest_array_type="mismatch_warning">
			<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
		</option>
		<setting name="console_application" value="true"/>
		<setting name="total_order_on_reals" value="false"/>
		<setting name="dead_code_removal" value="feature"/>
		<library name="base" location="$AP/library/base/base.ecf" />
		<cluster name="project" location=".\" recursive="true">
			<option warning="none" is_obsolete_iteration="true" manifest_array_type="mismatch_warning"/>
		</cluster>
	</target>
</system>

```
and the following eiffel file:
```
note
	description: "Exmaple class for testing autoproof with docker."

class
	LINEAR_SEARCH

feature
	linear_search (a: SIMPLE_ARRAY [INTEGER])
		do
			check False end
		end
end
```

