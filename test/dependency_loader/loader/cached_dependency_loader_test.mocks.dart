// Mocks generated by Mockito 5.4.4 from annotations
// in json_dynamic_widget_plugin_components/test/dependency_loader/loader/cached_dependency_loader_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:json_dynamic_widget/json_dynamic_widget.dart' as _i2;
import 'package:json_dynamic_widget_plugin_components/src/dependency_loader/dependency.dart'
    as _i5;
import 'package:json_dynamic_widget_plugin_components/src/dependency_loader/loader/dependency_loader.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWidget_0 extends _i1.SmartFake implements _i2.Widget {
  _FakeWidget_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i2.DiagnosticLevel? minLevel = _i2.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeInheritedWidget_1 extends _i1.SmartFake
    implements _i2.InheritedWidget {
  _FakeInheritedWidget_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i2.DiagnosticLevel? minLevel = _i2.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeDiagnosticsNode_2 extends _i1.SmartFake
    implements _i2.DiagnosticsNode {
  _FakeDiagnosticsNode_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({
    _i2.TextTreeConfiguration? parentConfiguration,
    _i2.DiagnosticLevel? minLevel = _i2.DiagnosticLevel.info,
  }) =>
      super.toString();
}

/// A class which mocks [DependencyLoader].
///
/// See the documentation for Mockito's code generation for more information.
class MockDependencyLoader extends _i1.Mock implements _i3.DependencyLoader {
  @override
  _i4.Future<String?> load(
    _i5.Dependency? dependency,
    _i2.BuildContext? context,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #load,
          [
            dependency,
            context,
          ],
        ),
        returnValue: _i4.Future<String?>.value(),
        returnValueForMissingStub: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
}

/// A class which mocks [BuildContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildContext extends _i1.Mock implements _i2.BuildContext {
  @override
  _i2.Widget get widget => (super.noSuchMethod(
        Invocation.getter(#widget),
        returnValue: _FakeWidget_0(
          this,
          Invocation.getter(#widget),
        ),
        returnValueForMissingStub: _FakeWidget_0(
          this,
          Invocation.getter(#widget),
        ),
      ) as _i2.Widget);

  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  bool get debugDoingBuild => (super.noSuchMethod(
        Invocation.getter(#debugDoingBuild),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i2.InheritedWidget dependOnInheritedElement(
    _i2.InheritedElement? ancestor, {
    Object? aspect,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #dependOnInheritedElement,
          [ancestor],
          {#aspect: aspect},
        ),
        returnValue: _FakeInheritedWidget_1(
          this,
          Invocation.method(
            #dependOnInheritedElement,
            [ancestor],
            {#aspect: aspect},
          ),
        ),
        returnValueForMissingStub: _FakeInheritedWidget_1(
          this,
          Invocation.method(
            #dependOnInheritedElement,
            [ancestor],
            {#aspect: aspect},
          ),
        ),
      ) as _i2.InheritedWidget);

  @override
  void visitAncestorElements(_i2.ConditionalElementVisitor? visitor) =>
      super.noSuchMethod(
        Invocation.method(
          #visitAncestorElements,
          [visitor],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void visitChildElements(_i2.ElementVisitor? visitor) => super.noSuchMethod(
        Invocation.method(
          #visitChildElements,
          [visitor],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispatchNotification(_i2.Notification? notification) =>
      super.noSuchMethod(
        Invocation.method(
          #dispatchNotification,
          [notification],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.DiagnosticsNode describeElement(
    String? name, {
    _i2.DiagnosticsTreeStyle? style = _i2.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeElement,
          [name],
          {#style: style},
        ),
        returnValue: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeElement,
            [name],
            {#style: style},
          ),
        ),
        returnValueForMissingStub: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeElement,
            [name],
            {#style: style},
          ),
        ),
      ) as _i2.DiagnosticsNode);

  @override
  _i2.DiagnosticsNode describeWidget(
    String? name, {
    _i2.DiagnosticsTreeStyle? style = _i2.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeWidget,
          [name],
          {#style: style},
        ),
        returnValue: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeWidget,
            [name],
            {#style: style},
          ),
        ),
        returnValueForMissingStub: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeWidget,
            [name],
            {#style: style},
          ),
        ),
      ) as _i2.DiagnosticsNode);

  @override
  List<_i2.DiagnosticsNode> describeMissingAncestor(
          {required Type? expectedAncestorType}) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeMissingAncestor,
          [],
          {#expectedAncestorType: expectedAncestorType},
        ),
        returnValue: <_i2.DiagnosticsNode>[],
        returnValueForMissingStub: <_i2.DiagnosticsNode>[],
      ) as List<_i2.DiagnosticsNode>);

  @override
  _i2.DiagnosticsNode describeOwnershipChain(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeOwnershipChain,
          [name],
        ),
        returnValue: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeOwnershipChain,
            [name],
          ),
        ),
        returnValueForMissingStub: _FakeDiagnosticsNode_2(
          this,
          Invocation.method(
            #describeOwnershipChain,
            [name],
          ),
        ),
      ) as _i2.DiagnosticsNode);
}
