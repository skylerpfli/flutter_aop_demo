// Transformer/visitor for toString
// If we add any more of these, they really should go into a separate library.

import 'package:kernel/ast.dart';
import 'package:vm/target/flutter.dart';
import 'throttle_visitor.dart';

class HookTransformer extends FlutterProgramTransformer {

  @override
  void transform(Component component) {
    ThrottleVisitor().start(component);
  }
}
