import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import '../../json_dynamic_widget_plugin_components.dart';

/// A registry that holds the used dependency loader and version resolver
class DependencyRegistry {
  DependencyRegistry({
    required DependencyLoader loader,
    required DependencyVersionResolver versionResolver,
  })  : _loader = loader,
        _versionResolver = versionResolver;

  static final DependencyRegistry _instance = DependencyRegistry(
    loader: MemoryDependencyLoader(dependencyData: {}),
    versionResolver: RequiredDependencyVersionResolver(),
  );

  static DependencyRegistry get instance => _instance;

  set loader(DependencyLoader loader) {
    _loader = loader;
  }

  set versionResolver(DependencyVersionResolver versionResolver) {
    _versionResolver = versionResolver;
  }

  Future<String?> load(Dependency dependency, BuildContext context) async {
    return _loader.load(dependency, context);
  }

  Future<String> resolveVersion(
    String name,
    String? version,
    BuildContext context,
  ) {
    return _versionResolver.resolve(name, version, context);
  }

  DependencyLoader _loader;
  DependencyVersionResolver _versionResolver;
}
