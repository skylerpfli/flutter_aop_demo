# flutter_aop_demo

### Flutte Aop 可复用极简Demo 

- [x] **「极简」** 最少的改造和集成代码
- [x] **「低风险」** 不影响其他工程编译流程
- [x] **「可复用」** 简单几步即可在项目中实现Aop能力

通过AST语法树操纵实现，有一个简单的插桩例子，@HookType()标记的方法会自行打印参数类型。

适配版本：Flutter 2.2.0

![image](https://user-images.githubusercontent.com/40731589/144044938-57425bf3-991d-4a22-9b29-467f7f09c89f.png)

-----------
### 一、如何复用Aop能力
① 对FlutterSdk打补丁
```
//flutterSdk目录
cd xxx/flutter
git apply --3way aop_flutter_sdk_2.2.0.patch
rm bin/cache/flutter_tools.stamp 
```
② 拷贝Demo中transform文件夹到项目根目录下。

以上，即可在tranfrom工程中写入对该项目的插桩逻辑。

### 二、运行与调试
#### 1.依赖

