# Flutter Aop 可复用的极简Demo 
通过AST语法树操纵实现，适配版本：Flutter 2.2.0

- [x] **「极简」** 最少的改造和集成代码
- [x] **「低风险」** 不影响其他工程编译流程
- [x] **「可复用」** 简单几步即可在项目中实现Aop能力

Demo中有一个简单的插桩例子，@HookType()标记的方法会自行打印参数类型。

![image](https://user-images.githubusercontent.com/40731589/144044938-57425bf3-991d-4a22-9b29-467f7f09c89f.png)

### 一、如何复用Aop能力
① 对FlutterSdk打补丁
```
cd xxx/flutter
git apply --3way aop_flutter_sdk_2.2.0.patch
rm bin/cache/flutter_tools.stamp 
```
② 拷贝Demo中transform文件夹到项目根目录下。

以上，即可在tranfrom工程中写入对该项目的插桩逻辑。

<br/>

### 二、运行与调试
#### 1. 处理依赖
① clone dart依赖仓库：
```
git clone https://github.com/skylerpfli/DartSdkHook.git
```

②备份 [flutter_frontend_server/package_config.json](https://github.com/skylerpfli/flutter_aop_demo/blob/main/transform/lib/flutter_frontend_server/package_config.json)，并把其中的`../../../third_party/dart`改为`file:///Users/xxx/dartSdkHook` (本地dart依赖仓库路径)

③把该备份的package_config.json拷贝进transfrom/.dart_tool文件夹下并覆盖。(无该路径则在tranfrom文件夹下执行`flutter pub get`)

此时tranfrom文件夹import正常，无报红。（项目pub get后需要重复此步骤）

--
#### 2. 创建调试
补丁已在flutter_tools创建对应日志，运行项目工程及可查看。需要的是启动frontend_server参数(--sdk-root及其以后)
![image](https://user-images.githubusercontent.com/40731589/144049862-c9a9eecd-51dc-4107-86ce-694368693264.png)

在AndroidStudio建立`Dart Command Line`

![image](https://user-images.githubusercontent.com/40731589/144050636-8b59c232-700c-4a02-9f83-34965a4fc8f5.png)

并配置启动入口为[starter.dart](https://github.com/skylerpfli/flutter_aop_demo/blob/main/transform/lib/flutter_frontend_server/starter.dart)， 参数为上文frontend_server参数，工程目录为本工程目录。
![image](https://user-images.githubusercontent.com/40731589/144051356-c92624ad-f236-4dce-a226-695c671d7f4d.png)

断点后，点击debug后即可调试


