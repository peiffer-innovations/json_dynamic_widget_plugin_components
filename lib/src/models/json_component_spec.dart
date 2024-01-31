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
      Map<String, dynamic> json, JsonWidgetRegistry? registry) {
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

  final String name;
  final Version? version;
  late final List<InputSpec> inputs;
  late final List<OutputSpec> outputs;
  final Map<String, dynamic> content;

  static const nameKey = 'name';
  static const versionKey = 'version';
  static const inputsKey = 'inputs';
  static const outputsKey = 'outputs';
  static const contentKey = 'content';

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      nameKey: name,
      versionKey: version?.toString(),
      inputsKey: inputs.map((input) => input.toJson()).toList(),
      outputsKey: outputs.map((output) => output.toJson()).toList(),
      contentKey: json.encode(content),
    };
  }
}

class InputSpec extends JsonClass {
  InputSpec({
    required this.name,
    required this.description,
    required this.defaultValue,
  });

  factory InputSpec.fromJson(Map<String, dynamic> json) => InputSpec(
        name: json[nameKey]!,
        description: json[descriptionKey]!,
        defaultValue: json[defaultValueKey]!,
      );

  final String name;
  final String? description;
  final dynamic defaultValue;

  static const nameKey = 'name';
  static const descriptionKey = 'description';
  static const defaultValueKey = 'defaultValue';

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      nameKey: name,
      descriptionKey: description,
      defaultValueKey: defaultValue,
    };
  }
}

class OutputSpec extends JsonClass {
  OutputSpec({required this.name, required this.description});

  factory OutputSpec.fromJson(Map<String, dynamic> json) =>
      OutputSpec(name: json[nameKey]!, description: json[descriptionKey]!);

  final String name;
  final String description;

  static const nameKey = 'name';
  static const descriptionKey = 'description';

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      nameKey: name,
      descriptionKey: description,
    };
  }
}
