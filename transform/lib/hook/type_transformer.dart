// Transformer/visitor for toString
// If we add any more of these, they really should go into a separate library.

import 'type_recursive_visitor.dart';
import 'package:kernel/ast.dart';
import 'package:vm/target/flutter.dart';

/// 通过@HookType注解，打印方法参数类型
class TypeTransformer extends FlutterProgramTransformer {
  static Reference? printTypeReference; //存储插入的方法

  TypeTransformer();

  static const _targetLibrary = "package:annotation/inject/type_helper.dart";
  static const _targetProcedure = "printType";

  @override
  void transform(Component component) {
    prepare(component);
    if (printTypeReference == null) {
      print('TypeTransformer，未找到插入节点：$_targetLibrary $_targetProcedure');
      return;
    }

    ///开始插桩
    component.visitChildren(TypeRecursiveVisitor());
  }

  /// 获取插入的方法节点
  void prepare(Component component) {
    final List<Library> libraries = component.libraries;
    if (libraries.isEmpty) {
      return;
    }

    // 根据library和方法名定位
    for (Library library in libraries) {
      if (library.importUri.toString() == _targetLibrary) {
        for (Procedure procedure in library.procedures) {
          if (procedure.name.text == _targetProcedure) {
            printTypeReference = procedure.reference;
          }
        }
      }
    }
  }
}
