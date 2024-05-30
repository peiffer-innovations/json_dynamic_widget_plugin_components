import 'package:flutter/material.dart';

import '../../../json_dynamic_widget_plugin_components.dart';

class CachedRefLoader implements DependencyLoader {
  CachedRefLoader({required DependencyLoader cachedLoader})
      : _cachedLoader = cachedLoader;

  final DependencyLoader _cachedLoader;
  final Map<Dependency, String> _cachedData = {};

  @override
  Future<String?> load(Dependency ref, BuildContext context) async {
    String? refData;
    if (_cachedData.containsKey(ref)) {
      refData = _cachedData[ref]!;
    } else {
      refData = await _cachedLoader.load(ref, context);
      if (refData != null && refData.isNotEmpty) {
        _cachedData[ref] = refData;
      }
    }
    return refData;
  }
}
