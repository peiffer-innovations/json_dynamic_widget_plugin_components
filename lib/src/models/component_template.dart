import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:version/version.dart';

class ComponentTemplate extends JsonClass {
  ComponentTemplate({
    required this.name,
    required this.version,
    this.values = const <ValueTemplate>[],
    required this.content,
  });
  factory ComponentTemplate.fromJson(
      Map<String, dynamic> json, JsonWidgetRegistry? registry) {
    return ComponentTemplate(
      name: json[nameKey]!,
      version:
          json[versionKey] != null ? Version.parse(json[versionKey]) : null,
      values: json[valuesKey] != null
          ? (json[valuesKey] as List<dynamic>)
              .map((e) => ValueTemplate.fromJson(e))
              .toList()
          : [],
      content: Map<String, dynamic>.from(json[contentKey]),
    );
  }

  final String name;
  final Version? version;
  late final List<ValueTemplate> values;
  final Map<String, dynamic> content;

  static const nameKey = 'name';
  static const versionKey = 'version';
  static const valuesKey = 'values';
  static const contentKey = 'content';

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      nameKey: name,
      versionKey: version?.toString(),
      valuesKey: values.map((e) => e.toJson()).toList(),
      contentKey: json.encode(content),
    };
  }
}

class ValueTemplate extends JsonClass {
  ValueTemplate(
      {required this.name,
      required this.description,
      required this.defaultValue});

  factory ValueTemplate.fromJson(Map<String, dynamic> json) => ValueTemplate(
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
