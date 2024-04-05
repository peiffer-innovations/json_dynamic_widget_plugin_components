import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:version/version.dart';

class ComponentSpec extends JsonClass {
  ComponentSpec({
    required this.name,
    required this.version,
    this.inputs = const <InputSpec>[],
    this.outputs = const <OutputSpec>[],
    required this.content,
  });

  factory ComponentSpec.fromJson(
    Map<String, dynamic> json,
    JsonWidgetRegistry? registry,
  ) {
    return ComponentSpec(
      name: json[nameKey]!,
      version:
          json[versionKey] != null ? Version.parse(json[versionKey]) : null,
      inputs: json[inputsKey] != null
          ? (json[inputsKey] as List<dynamic>)
              .map((inputSpecRaw) =>
                  InputSpec.fromJson(Map<String, dynamic>.from(inputSpecRaw)))
              .toList()
          : [],
      outputs: json[outputsKey] != null
          ? (json[outputsKey] as List<dynamic>)
              .map((outputSpecRaw) =>
                  OutputSpec.fromJson(Map<String, dynamic>.from(outputSpecRaw)))
              .toList()
          : [],
      content: Map<String, dynamic>.from(json[contentKey]),
    );
  }

  static const contentKey = 'content';
  static const inputsKey = 'inputs';
  static const nameKey = 'name';
  static const outputsKey = 'outputs';
  static const versionKey = 'version';

  final Map<String, dynamic> content;
  late final List<InputSpec> inputs;
  final String name;
  late final List<OutputSpec> outputs;
  final Version? version;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      contentKey: json.encode(content),
      inputsKey: inputs.map((input) => input.toJson()).toList(),
      nameKey: name,
      outputsKey: outputs.map((output) => output.toJson()).toList(),
      versionKey: version?.toString(),
    };
  }
}

class InputSpec extends JsonClass {
  InputSpec({
    required this.defaultValue,
    required this.description,
    required this.name,
  });
  factory InputSpec.fromJson(Map<String, dynamic> json) => InputSpec(
        defaultValue: json[defaultValueKey]!,
        description: json[descriptionKey]!,
        name: json[nameKey]!,
      );

  static const defaultValueKey = 'defaultValue';
  static const descriptionKey = 'description';
  static const nameKey = 'name';

  final dynamic defaultValue;
  final String? description;
  final String name;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      defaultValueKey: defaultValue,
      descriptionKey: description,
      nameKey: name,
    };
  }
}

class OutputSpec extends JsonClass {
  OutputSpec({
    required this.description,
    required this.name,
  });
  factory OutputSpec.fromJson(Map<String, dynamic> json) => OutputSpec(
        description: json[descriptionKey]!,
        name: json[nameKey]!,
      );

  static const descriptionKey = 'description';
  static const nameKey = 'name';

  final String description;
  final String name;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      descriptionKey: description,
      nameKey: name,
    };
  }
}
