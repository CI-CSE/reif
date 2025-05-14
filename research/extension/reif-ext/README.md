# reif-ext
This folder contains the base ECF and service classes for Reif extensions.

This setup helps to make extension in a modular way in two senses:
1. Extensions are compiled into base EiffelStudio without touching
  the EiffelStudio code.
  This is achieved using the `[ES_]SERVICE_INITIALIZER_EXTENSION` classes.
  Both `bench` and `batch` targets are available for producing the minimal
  required build.
2. Extensions can be based on other extensions.
  This is achieved by using `extends` in the ECFs to base an extension
  on another extension.

## Basic structure
Extensions are advised to use the following file structure for interoperability.

File names are using **demo** and **parent** as placeholders
for the actual extension names.

* `/demo-ext.ecf` defines abstract targets `batch` and `bench` which
  extend `parent-ext.ecf` or `reif-ext.ecf` if no
  parent extension is needed.
* `/demo.ecf` defines the concrete executable targets `batch` and `bench`
  which extend `demo-ext.ecf` and add the `demo-initializers` cluster
  discussed below.
* `/extension/` folder for the `demo-extension` cluster
  which defines classes for initializing services.
  * `/extension/demo_batch_service_initializer_extension.e` must
    inherit from `REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION`.
	It registers command-line services for the extension.
	It can inherit the respective classes from the parent extensions
	(`PARENT_BATCH_SERVICE_INITIALIZER_EXTENSION`).
  * `/extension/bench/` folder defines GUI service extensions initializers.
    This folder must be included only in the `bench` target.
    * `/extension/bench/demo_service_initializer_extension.e` defines
	  the CLI extensions for the `bench` target.
	  This class must inherit `SERVICE_INITIALIZER_EXTENSION` EiffelStudio class.
	  It must be enough to inherit `DEMO_BATCH_SERVICE_INITIALIZER_EXTENSION`
	  and merge the `add_core_services` feature.
	* `/extension/bench/demo_es_service_initializer_extension.e` defines
	  the GUI extensions for the `bench` target.
	  This class must inherit
	* `/extension/bench/demo_es_tool_menu_extension.e` (OPTIONAL) the Tool Menu extension
	* `/extension/bench/demo_es_context_menu_extension.e` (OPTIONAL) the Context Menu extension
* `/service-initializers/` folder for the `demo-initializers` cluster
  which contains concrete service initializer extension classes.
  These classes must be used only in `demo.ecf` and not in `demo-ext.ecf`.
  The classes in this folder must simply inherit from classes
  in the `/extension/` folder.
  * `/service-initializers/batch_service_initializer_extension.e`
     is the service initializer for the `batch` target.
	 It should simply inherit `DEMO_BATCH_SERVICE_INITIALIZER_EXTENSION`
	 from the `/extension/` folder.
  * `/service-initializers/bench/` folder for `bench`-target specific
    initializers
	* `/service-initializers/bench/service_initializer_extension.e`
	  is the CLI extensions initializer used in the `bench` target
	* `/service-initializers/bench/es_service_initializer_extension.e`
	  is the GUI extensions initializer used in the `bench` target

### `demo-ext.ecf` — base targets, reusable for extension
The `bench` and `batch` targets extend the previous extension targets.
This target is not meant to be executed, but is meant to be extended
by other extensions.

The minimal targets defines the extension cluster for the `/extension/` folder.

The `batch` target must ignore the `bench` folder because it contains
GUI-related classes.

``` xml
<target name="bench" extends="bench" extends_location="$EIFFEL_SRC\..\research\extension\reif-ext\reif-ext.ecf">
  <cluster name="extension" location="extension" recursive="true"/>
</target>

<target name="batch" extends="batch" extends_location="$EIFFEL_SRC\..\research\extension\reif-ext\reif-ext.ecf">
  <cluster name="extension" location="extension" recursive="true">
    <file_rule>
      <exclude>bench/</exclude>
    </file_rule>
  </cluster>
</target>
```

### `demo.ecf` — executable targets
The `bench` and `batch` targets extend the targets from `demo-ext.ecf`.

Since `SERVICE_INITIALIZER_EXTENSION`, `ES_SERVICE_INITIALIZER_EXTENSION`,
`BATCH_SERVICE_INITIALIZER_EXTENSION` classes are loaded in runtime
by name and are never referenced in the program, we need to
make them `<visible>` so that they are present in the executable
and not removed as dead code.

Again, `batch` target must ignore GUI related classes in the `bench` folder.

``` xml
<target name="bench" extends="bench" extends_location="extension-ext.ecf">
  <cluster name="demo-initializers" location="service-initializers" recursive="true">
    <visible class="ES_SERVICE_INITIALIZER_EXTENSION" feature="default_create"/>
    <visible class="SERVICE_INITIALIZER_EXTENSION" feature="add_core_services"/>
  </cluster>
</target>


<target name="batch" extends="batch" extends_location="extension-ext.ecf">
  <cluster name="demo-initializer" location="service-initializers" recursive="true">
    <file_rule>
      <exclude>bench/</exclude>
    </file_rule>
    <visible class="BATCH_SERVICE_INITIALIZER_EXTENSION" feature="add_core_services"/>
  </cluster>
</target>
```
