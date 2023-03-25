// ignore: implementation_imports
import 'package:front_end/src/fasta/kernel/internal_ast.dart';
import 'package:kernel/ast.dart';

///防抖动
class ThrottleVisitor extends RecursiveVisitor<void> {
  static Reference isQuickReference; //存储插入的方法

  static Reference stringClassReference; // String类节点

  static Reference intClassReference; // int类节点

  static Reference intToStringReference; // int.toString节点

  static Reference targetHashCodeReference; // Object.hashCode节点

  // 常量
  static const String _targetThrottleLibrary = "throttle_helper";
  static const String _targetThrottleMethod = "isTooQuick";

  static const String _targetCoreLibrary = "dart:core";
  static const String _targetStringClass = "String";

  static const String _targetIntClass = "int";
  static const String _targetIntToStringMethod = "toString";

  static const String _targetObjectClass = "Object";
  static const String _targetHashCodeMethod = "hashCode";

  // 开始插桩
  void start(Component component) {
    if (prepare(component) /**准备节点*/) {
      component.visitChildren(this); // 递归遍历
    }
  }

  // 预备节点
  bool prepare(Component component) {
    for (Library library in component.libraries) {
      // isTooQuick节点
      if (library.name == _targetThrottleLibrary) {
        for (Procedure procedure in library.procedures) {
          if (procedure.name.text == _targetThrottleMethod) {
            isQuickReference = procedure.reference;
          }
        }
      }

      if (_targetCoreLibrary == library.importUri.toString()) {
        for (Class clazz in library.classes) {
          // String节点
          if (clazz.name == _targetStringClass) {
            stringClassReference = clazz.reference;
          }

          // int节点
          if (clazz.name == _targetIntClass) {
            intClassReference = clazz.reference;
            for (Procedure procedure in clazz.procedures) {
              if (procedure.name.text == _targetIntToStringMethod) {
                intToStringReference = procedure.reference;
              }
            }
          }

          // Object节点
          if (clazz.name == _targetObjectClass) {
            for (Procedure procedure in clazz.procedures) {
              if (procedure.name.text == _targetHashCodeMethod) {
                targetHashCodeReference = procedure.reference;
              }
            }
          }
        }
      }
    }

    if (isQuickReference == null || stringClassReference == null || intToStringReference == null || intClassReference == null || targetHashCodeReference == null) {
      print('ThrottleTransformer error!  isQuickExecuteReference: $isQuickReference, stringClassReference: $stringClassReference, intToStringReference: $intToStringReference, intClassReference: $intClassReference, targetHashCodeReference: $targetHashCodeReference');
      return false;
    }

    return true;
  }

  @override
  void visitProcedure(Procedure node) {
    super.visitProcedure(node);

    /// 命中条件
    var throttleData = checkThrottle(node);
    if (throttleData == null) {
      return;
    }

    //key，方法的唯一标识符号
    String key;
    if (node.isStatic) {
      if (node.parent is Library) {
        key = '${(node.parent as Library).importUri.path}_${node.name.text}';
      } else if (node.parent is Class) {
        key = '${(node.parent.parent as Library).importUri.path}_${(node.parent as Class).name}_${node.name.text}';
      }
    }

    /// 构造新节点
    StaticInvocation isQuickInvocation;
    if (key != null || node.isStatic) {
      isQuickInvocation = StaticInvocation.byReference(isQuickReference, ArgumentsImpl(<Expression>[StringLiteral(key ?? ''), IntJudgment(throttleData.intervalTime, '${throttleData.intervalTime}'), StringLiteral(throttleData.tips)]));
    } else {
      //类方法key需要用hashCode动态生成
      isQuickInvocation = StaticInvocation.byReference(
          isQuickReference,
          ArgumentsImpl(<Expression>[
            InstanceInvocation(InstanceAccessKind.Instance, InstanceGet(InstanceAccessKind.Instance, ThisExpression(), Name('hashCode'), interfaceTarget: targetHashCodeReference.asProcedure, resultType: InterfaceType.byReference(intClassReference, Nullability.nonNullable, [])), Name('toString'), Arguments.empty(),
                functionType: FunctionType([], InterfaceType.byReference(stringClassReference, Nullability.nonNullable, []), Nullability.nonNullable), interfaceTarget: intToStringReference.asProcedure),
            IntJudgment(throttleData.intervalTime, '${throttleData.intervalTime}'),
            StringLiteral(throttleData.tips)
          ]));
    }

    // 构建 if - then
    final Block thenReturnBlock = Block(<Statement>[ReturnStatementImpl(false)]);
    final IfStatement ifStatement = IfStatement(isQuickInvocation, thenReturnBlock, null);

    // 插入代码块
    final Statement body = node.function.body;
    if (body is Block) {
      final Block blockBody = body;
      blockBody.statements.insert(0, ifStatement);
    } else {
      final Block newBlock = Block(<Statement>[ifStatement, body]);
      node.function.body = newBlock;
    }
  }

  // 检查Throttle注解
  ThrottleData checkThrottle(Procedure node) {
    if (node.kind == ProcedureKind.Method) {
      final List<Expression> annotations = node.annotations;

      // 遍历函数注解
      for (Expression annotation in annotations) {
        if (annotation is ConstructorInvocation) {
          final ConstructorInvocation constructorInvocation = annotation;
          final Class cls = constructorInvocation?.targetReference?.node?.parent;

          // 命中函数
          if (cls.name == 'Throttle') {
            int intervalTime;
            String tips;

            // 获取参数
            if (constructorInvocation.arguments.named.isNotEmpty) {
              for (NamedExpression namedExpression in constructorInvocation.arguments.named) {
                if (namedExpression.name == 'time') {
                  final IntJudgment intJudgment = namedExpression?.value;
                  intervalTime = intJudgment?.value;
                } else if (namedExpression.name == 'tips') {
                  final StringLiteral stringLiteral = namedExpression?.value;
                  tips = stringLiteral?.value;
                }
              }
            }

            return ThrottleData(intervalTime, tips);
          }
        }
      }
    }
    return null;
  }
}

class ThrottleData {
  static const _defaultInternalTime = 200; //默认时间间隔
  static const _defaultTip = ""; //默认提示

  int intervalTime;
  String tips;

  ThrottleData(int intervalTime, String tips) {
    this.intervalTime = intervalTime ?? _defaultInternalTime;
    this.tips = tips ?? _defaultTip;
  }
}
