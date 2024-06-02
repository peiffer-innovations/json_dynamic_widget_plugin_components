import 'package:json_dynamic_widget/json_dynamic_widget.dart';

@immutable
class Dependency {
  const Dependency({
    required this.name,
    required this.version,
  });

  final String name;
  final String version;

  @override
  int get hashCode => name.hashCode ^ version.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Dependency &&
        other.name == name &&
        other.runtimeType == runtimeType &&
        other.version == version;
  }
}
