import 'package:kernel/ast.dart';

class NodeUtils {
  static const String kAnnotationClass = 'HookType';
  static String kImportUri = 'package:annotation/hook_type.dart';

  /// @HookType 目标类
  static bool checkIfClassEnable(List<Expression> annotations) {
    bool enabled = false;
    for (Expression annotation in annotations) {
      //注解有ConstantExpression和ConstructorInvocation两种形式
      if (annotation is ConstantExpression) {
        final ConstantExpression constantExpression = annotation;
        final Constant constant = constantExpression.constant;
        if (constant is InstanceConstant) {
          final InstanceConstant instanceConstant = constant;
          final Class? instanceClass = instanceConstant.classNode;
          //@HookType注解
          if (instanceClass?.name == kAnnotationClass && kImportUri == (instanceClass?.parent as Library).importUri.toString()) {
            enabled = true;
            break;
          }
        }
      } else if (annotation is ConstructorInvocation) {
        final ConstructorInvocation constructorInvocation = annotation;
        final Class? cls = constructorInvocation.target.parent as Class;
        if (cls == null) {
          continue;
        }
        final Library library = cls.parent as Library;
        if (cls.name == kAnnotationClass && kImportUri == library.importUri.toString()) {
          enabled = true;
          break;
        }
      }
    }
    return enabled;
  }
}
