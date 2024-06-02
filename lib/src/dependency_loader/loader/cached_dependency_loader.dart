import 'package:flutter/material.dart';

import '../../../json_dynamic_widget_plugin_components.dart';

/// Loader that caches the content of the child loader in the in-memory map.
/// It allows to
class CachedDependencyLoader implements DependencyLoader {
  CachedDependencyLoader({required DependencyLoader cachedLoader})
      : _cachedLoader = cachedLoader;

  final DependencyLoader _cachedLoader;
  final Map<Dependency, String> _cachedData = {};

  @override
  Future<String?> load(Dependency dependency, BuildContext context) async {
    String? dependencyData;
    if (_cachedData.containsKey(dependency)) {
      dependencyData = _cachedData[dependency]!;
    } else {
      dependencyData = await _cachedLoader.load(dependency, context);
      if (dependencyData != null && dependencyData.isNotEmpty) {
        _cachedData[dependency] = dependencyData;
      }
    }
    return dependencyData;
  }
}
