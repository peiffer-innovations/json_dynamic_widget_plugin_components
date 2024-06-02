<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [json_dynamic_widget_plugin_components](#json_dynamic_widget_plugin_components)
  - [Table of Contents](#table-of-contents)
  - [Live Example](#live-example)
  - [Introduction](#introduction)
  - [About](#about)
    - [Dependency loaders](#dependency-loaders)
    - [Dependency version resolvers](#dependency-version-resolvers)
    - [Component spec](#component-spec)
    - [Component values encapsulation](#component-values-encapsulation)
  - [Using the Plugin](#using-the-plugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# json_dynamic_widget_plugin_components

## Table of Contents

- [json\_dynamic\_widget\_plugin\_components](#json_dynamic_widget_plugin_components)
  - [Table of Contents](#table-of-contents)
  - [Live Example](#live-example)
  - [Introduction](#introduction)
  - [About](#about)
    - [Dependency loaders](#dependency-loaders)
    - [Dependency version resolvers](#dependency-version-resolvers)
    - [Component spec](#component-spec)
    - [Component values encapsulation](#component-values-encapsulation)
  - [Using the Plugin](#using-the-plugin)


## Live Example

* [Web](https://peiffer-innovations.github.io/json_dynamic_widget_plugin_components/web/index.html#/)


## Introduction

Plugin to the [JSON Dynamic Widget](https://peiffer-innovations.github.io/json_dynamic_widget) which allows to combine the set of JSON widgets into one -> component.

## About

### Dependency loaders
Dependency is a combination of a `name` and a `version`.

Loaders are used to load components in a raw format from the different sources.

Each loader needs to implement the `load` method:
```
    Future<String?> load(Dependency dependency, BuildContext context);
```

Currently supported loaders:
- **AssetDependencyLoader** : Loads the dependency from the assets. Can be configured via `AssetPathResolver` which specifies how `Dependency` is resolved to the path.
- **MemoryDependencyLoader** : Loads the dependency from the in-memory map.
- **CachedDependencyLoader** : Caches the result of the child dependency loader.

### Dependency version resolvers
Dependency version resolvers allow to define custom version resolving strategies. 
For example in case of the missing version string it is possible to define
the logic of looking for the  `latest` version.

Each loader needs to implement the resolve method:
```
Future<String> resolve(String name, String? version, BuildContext context);
```

Currently supported version resolvers:
- **RequiredDependencyVersionResolver** : Requires the version string to be present in the dependency and throw the error if it's not.

### Component spec
Component specification defines the version, name and the set of inputs and outputs.
It's content is just the group of widgets which are used to build the component.

Fields definition:
- **name** - component name
- **version** - component version
- **inputs** - list of input variables and their default values
- **outputs** - list of output variables that can be used outside of the component
- **content** - group of the widgets which uses the inputs and produces the outputs variables

Example:
```
name: centered_text
version: 1.0.0
inputs:
- name: text
  description: The text value
  defaultValue: ''
outputs: []
content:
  type: center
  listen:
  - text
  args:
    child:
      type: text
      args:
        text: "${'This text is centered:' + text ?? ''}"
```


### Component values encapsulation
Each component can have it's own values.

To avoid name collisions each component have also it's own, separate registry.

Each component allow to define it's own inputs and outputs:
* `inputs` - the input variables of the component, that are available for the component registry. Not passing any values on caller side means that the default values will be used. If the value of the input uses `variables` then each update will be passed to the component registry.
* `outputs` - the output variables of the component, that can be exported to caller registry. Not passing any values means on caller side means that specific variable is not exported to the caller registry.

For e.g.
```
"type": "component",
"args": {
    "name": "header",
    "inputs": {
      "text": "Some text for the header"
    },
    "outputs": {
        "header_click_count" : "header1_click_count"
    }
}
```


## Using the Plugin

1. Bind the plugin.

```dart
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/json_dynamic_widget_plugin_components.dart';


void main() {
  // Ensure Flutter's binding is complete
  WidgetsFlutterBinding.ensureInitialized();

  // ...

  // Get an instance of the registry
  var registry = JsonWidgetRegistry.instance;

  // Bind the plugin to the registry. This is necessary for the registry to
  // find the widget provided by the plugin
  JsonComponentsPluginRegistrar.registerDefaults(registry: registry).withLoader(
    CachedDependencyLoader(
      cachedLoader: AssetDependencyLoader(
        pathResolver: DirAssetPathResolver(
          basePath: 'assets/components', // {components_path}
          ext: Ext.json,
          extByDependencyName: {
            'centered_text': Ext.yaml,
          },
        ),
      ),
    ),
  );

  // ...
}

```

2. Create the JSON file with component data and place it in `{components_path}/{component_name}/{version}.json`.

```
// {components_path}/custom_text_input/1.0.0.json
{
    "name": "custom_text_input",
    "version": "1.0.0",
    "inputs": [
        {
            "name": "label",
            "description": "The text input label",
            "defaultValue": ""
        },
                {
            "name": "hint",
            "description": "The text input hint",
            "defaultValue": ""
        }
    ],
    "outputs": [
        {
            "name": "text_input",
            "description": "The text input value"
        }
    ],
    "content": {
        "type": "text_form_field",
        "id": "text_input",
        "args": {
            "decoration": {
                "hintText": "${hint}",
                "labelText": "${label}",
                "suffixIcon": {
                    "type": "icon_button",
                    "args": {
                        "icon": {
                            "type": "icon",
                            "args": {
                                "icon": {
                                    "codePoint": 57704,
                                    "fontFamily": "MaterialIcons",
                                    "size": 50
                                }
                            }
                        },
                        "onPressed": "${set_value('text_input','')}"
                    }
                }
            },
            "validators": [
                {
                    "type": "required"
                }
            ]
        }
    }
}
```

3. Use the component in the `json_dynamic_widget`.

```
"type": "component",
"args": {
    "name": "custom_text_input",
    "version": "1.0.0", 
    "inputs": {
        "label": "First name",
        "hind": "John"
    },
    "outputs": {
        "text_input": "first_name_input_value"
    }
}
```