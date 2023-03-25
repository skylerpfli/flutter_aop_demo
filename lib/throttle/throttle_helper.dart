library throttle_helper;

import 'dart:collection';

/// create by skylerpfli，@Throttle所注入的代码

@pragma("vm:entry-point")
HashMap<String, int> cacheMap = HashMap(); //存储方法调用的时间

@pragma("vm:entry-point")
int _needCleanNum = 20; //当缓存超过该数值，则清理无用数据

@pragma("vm:entry-point")
int _maxIntervalTime = 10000; //最大间隔时间为10s

@pragma("vm:entry-point")
bool _isClearing = false;

//是否调用过快
@pragma("vm:entry-point")
bool isTooQuick(String key, int time, String tips) {
  if (time > _maxIntervalTime) {
    print('@Throttle error: over maxIntervalTime $_maxIntervalTime');
    return false;
  }

  final int now = DateTime.now().millisecondsSinceEpoch;
  if (cacheMap.containsKey(key)) {
    final int preCallTime = cacheMap[key]!;
    final int difTime = now - preCallTime;

    // 点击过快
    if (difTime < time) {
      print('@Throttle tooQuick, $tips, key: $key');
      cacheMap[key] = now;
      return true;
    }
  }

  if (cacheMap.length > _needCleanNum) {
    _cleanCache(now);
  }
  cacheMap[key] = now;
  return false;
}

//清除无用的缓存
@pragma("vm:entry-point")
void _cleanCache(int now) async {
  if (_isClearing) {
    return;
  }

  _isClearing = true;
  cacheMap.forEach((key, value) {
    if (now - value > _maxIntervalTime) {
      cacheMap.remove(key);
    }
  });

  //动态扩展缓存
  _needCleanNum = cacheMap.length + 20;
  _isClearing = false;
}
