import 'inject/type_helper.dart';

/// 打印方法参数的注解
class HookType {
  const factory HookType({int? time, String? tips}) = HookType._;

  const HookType._({int? time, String? tips});
}
