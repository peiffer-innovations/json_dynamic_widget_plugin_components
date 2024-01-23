<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [json_dynamic_widget_plugin_components](#json_dynamic_widget_plugin_components)
  - [Table of Contents](#table-of-contents)
  - [Live Example](#live-example)
  - [Introduction](#introduction)
  - [Using the Plugin](#using-the-plugin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# json_dynamic_widget_plugin_components

## Table of Contents

* [Live Example](#live-example)
* [Introduction](#introduction)
* [Using the Plugin](#using-the-plugin)


## Live Example

* [Web](https://peiffer-innovations.github.io/json_dynamic_widget_plugin_components/web/index.html#/)


## Introduction

Plugin to the [JSON Dynamic Widget](https://peiffer-innovations.github.io/json_dynamic_widget) which allows to combine  the set of JSON widgets into one and define 
own interface.

## About

### Component template loaders
Loaders are used to load components from the different sources.

Each loader needs to implement the `load` method:
```
Future<ComponentTemplate> load(BuildContext context, JsonWidgetRegistry? registry, String componentName, Version? version);
```

Currently supported loaders:
- AssetComponentTemplateLoader : Loads the components from the assets

### Component values encapsulation
Each component can have it's own values. Because of that we need to handle the issue of the name collision.
That's why each component have it's own registry.

For e.g.
```
"type": "component",
"args": {
    "name": "header",
    "values": {
      "text": "Some centered text"
    }
}
```

<!-- TODO Rethink the idea of exporting values from the component -->

### Versioning
Each component is versioned and placed in the following path:
`{components_path}/{component_name}/{version}.json`

Version is the optional arg. Lack of `version` will cause with taking always the latest one version of the component.

```
"type": "component",
"args": {
    "name": "footer",
    "version" : "1.0.0"
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

  // create valid component loader
  var basePath = 'assets/components'
  final loader = AssetComponentLoader(basePath);
  
  // Bind the plugin to the registry. This is necessary for the registry to
  // find the widget provided by the plugin
  JsonComponentsPlugin.bind(registry, loader);

  // ...
}

```

2. Create the JSON file with component data and place it in `{components_path}/{component_name}/{version}.json`.

```
// {components_path}/centered_text/1.0.0.json
{
    "name": "centered_text",
    "version": "1.0.0",
    "values": [
        {
            "name": "text",
            "description": "The centered text value.",
            "defaultValue": ""
        }
    ],
    "content": {
        "type": "center",
        "args": {
            "child": {
                "type": "text",
                "args": {
                    "text": "${text}"
                }
            }
        }
    }
}
```

3. Use the component in the `json_dynamic_widget`.

```
"type": "component",
"args": {
    "name": "centered_text",
    "version": "1.0.0", 
    "values": {
      "text": "Some centered text"
    }
}
```