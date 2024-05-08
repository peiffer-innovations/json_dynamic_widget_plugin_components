import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import '../dependency.dart';

abstract class DependencyLoader {
  // Loads the dependency data
  Future<String?> load(Dependency dependency, BuildContext context);
}
