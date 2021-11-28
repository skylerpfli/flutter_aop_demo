import 'package:flutter/material.dart';
import 'package:annotation/hook_type.dart';
import 'package:annotation/inject/type_helper.dart';

void main() {
  runApp(MyApp());
}

/// 测试@HookType插桩的示例页面，点击按钮后，_testTypeHook()会打印日志(@HookType)
@HookType()
void _testTypeHook(dynamic obj1, dynamic obj2, dynamic obj3) {
  //aop插桩位置
  //处理逻辑.., 这里什么都没做
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Aop Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Please click And see @HookType logs.',
              ),
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var obj1 = 123;
          var obj2 = "字符串对象";
          var obj3 = Container();

          _testTypeHook(obj1, obj2, obj3);
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
