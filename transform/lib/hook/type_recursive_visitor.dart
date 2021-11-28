import 'type_transformer.dart';
import 'package:kernel/ast.dart';
import 'node_utils.dart';

// ignore: implementation_imports
import 'package:front_end/src/fasta/kernel/internal_ast.dart';

/// 根据@HookType注解，打印方法的参数类型
class TypeRecursiveVisitor extends RecursiveVisitor {
  /// RecursiveVisitor递归遍历

  // 遍历所有方法
  @override
  void visitProcedure(Procedure node) {
    //如果方法命中@HookType注解
    if (NodeUtils.checkIfClassEnable(node.annotations)) {
      //需要添加的语句
      List<ExpressionStatement> statements = [];

      //位置参数
      node.function.positionalParameters.forEach((positionalParameter) {
        Statement statement = _buildStatement(positionalParameter);
        statements.add(statement);
      });

      //key-value参数
      node.function.namedParameters.forEach((namedParameter) {
        Statement statement = _buildStatement(namedParameter);
        statements.add(statement);
      });

      //方法体中插入插桩语句
      final Statement body = node.function.body;
      if (body is Block) {
        final Block blockBody = body;
        blockBody.statements.insertAll(0, statements);
      } else {
        if (body != null) {
          statements.add(body);
        }
        final Block newBlock = Block(statements);
        node.function.body = newBlock;
      }
    }
  }

  ///构建调用printType的语句
  ExpressionStatement _buildStatement(VariableDeclaration variableDeclaration) {
    //准备表达式的参数
    Expression variableGet = VariableGet(variableDeclaration);

    //构建表达式
    StaticInvocation staticInvocation = StaticInvocation.byReference(TypeTransformer.printTypeReference, ArgumentsImpl(<Expression>[variableGet]));

    //把表达式封装为语句，并返回
    return ExpressionStatement(staticInvocation);
  }
}
