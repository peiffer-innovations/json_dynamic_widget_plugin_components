import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget_plugin_components/src/dependency_loader/version/required_dependency_version_resolver.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<BuildContext>()])
import 'required_dependency_version_resolver_test.mocks.dart';

void main() {
  group('RequiredDependencyVersionResolver', () {
    late RequiredDependencyVersionResolver resolver;

    setUp(() {
      resolver = RequiredDependencyVersionResolver();
    });

    test('should return the provided version', () async {
      // given
      const name = 'dependency';
      const version = '1.0.0';
      final context = MockBuildContext();

      // when
      final resolvedVersion = await resolver.resolve(name, version, context);

      // then
      expect(resolvedVersion, version);
    });

    test('should throw an exception if version is null', () async {
      // given
      const name = 'dependency';
      const version = null;
      final context = MockBuildContext();

      // when/then
      expect(
        () => resolver.resolve(name, version, context),
        throwsException,
      );
    });

    test('should throw an exception if version is empty', () async {
      // given
      const name = 'dependency';
      const version = '';
      final context = MockBuildContext();

      // when/then
      expect(
        () => resolver.resolve(name, version, context),
        throwsException,
      );
    });
  });
}
