import 'throttle_helper.dart';

/// create by skylerpfli，防抖动的注解
///
/// time 间隔时间，低于这个值则进行拦截，毫秒
/// tips 拦截时打印的日志
/// */
class Throttle {
  const factory Throttle({int? time, String? tips}) = Throttle._;

  const Throttle._({int? time, String? tips});
}
