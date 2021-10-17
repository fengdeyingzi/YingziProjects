import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'BaseConfig.dart';
import 'page/LogoWidget.dart';
import 'page/QQChatLoginWidget.dart';
import 'page/QQChatWidget.dart';


void main() {
  try {
    BaseConfig.platform = Platform.operatingSystem;
    if (BaseConfig.platform == null) BaseConfig.platform = "web";
    print("当前平台 ${BaseConfig.platform}");
  } catch (error) {
    print("平台检测失败 web");
    BaseConfig.platform = "web";
  }
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '万能匣子',
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [
        BotToastNavigatorObserver()
      ], //2. registered route observer
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        "LogoWidget": (BuildContext context) => LogoWidget(),
        "QQChatMainWidget": (BuildContext context) => QQChatMainWidget(),
        "QQChatWidget": (BuildContext context) => QQChatWidget(),
      },
      // home: SelectWidget(),
      home:QQChatMainWidget(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  // final _controller = WebviewController();
  final _textController = TextEditingController();
/*
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    await _controller.initialize();
    _controller.url.listen((url) {
      _textController.text = url;
    });

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.loadUrl('https://flutter.cn');

    if (!mounted) return;

    setState(() {});
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 0,
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'URL',
                    contentPadding: EdgeInsets.all(10.0),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        _controller.reload();
                      },
                    )),
                textAlignVertical: TextAlignVertical.center,
                controller: _textController,
                onSubmitted: (val) {
                  _controller.loadUrl(val);
                },
              ),
            ),
            Expanded(
                child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      children: [
                        Webview(
                          _controller,
                          permissionRequested: _onPermissionRequested,
                        ),
                        StreamBuilder<LoadingState>(
                            stream: _controller.loadingState,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data == LoadingState.loading) {
                                return LinearProgressIndicator();
                              } else {
                                return Container();
                              }
                            }),
                      ],
                    ))),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
            title: StreamBuilder<String>(
          stream: _controller.title,
          builder: (context, snapshot) {
            return Text(
                snapshot.hasData ? snapshot.data : 'WebView (Windows) Example');
          },
        )),
        body: Center(
          child: compositeView(),
        ),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}

class MyApp3 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeChat Camera Picker Demo',
      theme: ThemeData(
        brightness: MediaQueryData.fromWindow(ui.window).platformBrightness,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeHomePage(),
    );
  }
}

class WeHomePage extends StatefulWidget {
  const WeHomePage({Key key}) : super(key: key);

  @override
  _WeHomePageState createState() => _WeHomePageState();
}

class _WeHomePageState extends State<WeHomePage> {
  AssetEntity entity;
  Uint8List data;

  Future<void> pick(BuildContext context) async {
    final Size size = MediaQuery.of(context).size;
    final double scale = MediaQuery.of(context).devicePixelRatio;
    final AssetEntity _entity = await CameraPicker.pickFromCamera(context,
        enableRecording: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
        resolutionPreset: ResolutionPreset.high);
    if (_entity != null && entity != _entity) {
      entity = _entity;
      if (mounted) {
        setState(() {});
      }
      data = await _entity.thumbDataWithSize(
        (size.width * scale).toInt(),
        (size.height * scale).toInt(),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseConfig.backgroundColor,
      appBar: AppBar(title: const Text('WeChat Camera Picker Demo')),
      /*
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (entity != null && data != null)
            Positioned.fill(
                child: PhotoView(
              imageProvider: AssetImage("assets/logo.png"),
            ))
          else if (entity != null && data == null)
            const Center(child: CircularProgressIndicator())
          else
            Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 320,
                  height: 320,
                  child: PhotoView(
                    imageProvider: AssetImage("assets/logo.png"),
                  ),
                ),
                Text('Click the button to start picking.')
              ],
            )),
          // data!=null ? Text("size = ${data.length}"):SizedBox()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pick(context),
        tooltip: 'Increment',
        child: const Icon(Icons.camera_enhance),
      ),*/
    );
  }
}
