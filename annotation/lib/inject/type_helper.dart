/// @HookType所注入的代码
@pragma("vm:entry-point")
void printType(dynamic object) {
  print("@HookType Type is: ${object?.runtimeType}");
}
