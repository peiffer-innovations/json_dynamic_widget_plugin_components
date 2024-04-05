import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/models/json_component_spec.dart';
import 'package:version/version.dart';

// TODO: Update this to be more like a registry where different loaders can be
//       registered.  This should then iterate through the loaders, find the one
//       that can load something, and use it.
//
//       Utilize URIs for loading.  So for example, take the following URIs:
//         * asset://component/foo.yaml --> AssetComponentSpecLoader
//         * https://component.com/foo.yaml --> NetworkComponentSpecLoader
//         * base64://$base64String --> MemoryComponentSpecLoader
//
//       That way loaders can register based on the URI's scheme and clients
//       can attach any number of loaders without them stepping on each other.
//       This also allows for future client provided schemes like:
//         * firebase:// ->> Load from Firebase Realtime Database
//         * storage:// ->> Load from Google Cloud Storage
//         * firestore:// ->> Load from Cloud Firestore
//         * s3:// ->> Load from AWS S3 Bucket
//         * ... and so on.
abstract class ComponentSpecLoader {
  static ComponentSpecLoader? _loader;

  // returns the ComponentLoader instance
  static ComponentSpecLoader get() {
    if (_loader == null) {
      throw Exception('ComponentSpecLoader not initialized');
    }
    return _loader!;
  }

  // initializes the ComponentLoader instance
  static void init(ComponentSpecLoader loader) {
    if (_loader != null) {
      throw Exception('ComponentSpecLoader already initialized');
    }
    _loader = loader;
  }

  // Loads the component specification based on the JSON structure. In case of
  // version being null, the loader should return the latest version of the
  // component.
  Future<ComponentSpec> load({
    required String componentName,
    required BuildContext context,
    JsonWidgetRegistry? registry,
    Version? version,
  });
}
