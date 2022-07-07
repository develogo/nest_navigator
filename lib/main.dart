import 'package:flutter/material.dart';

import 'src/detail_page.dart';

main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Routing Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/detail': (context) => const DetailPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Root App Bar'),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        color: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 72,
            color: Colors.red,
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Return to'),
                TextButton(
                  onPressed: () {
                    while (navigationKey.currentState!.canPop()) {
                      navigationKey.currentState!.pop();
                    }
                  },
                  child: const Text('Root'),
                ),
              ],
            ),
          ),
          Expanded(
            child: NestedNavigator(
              navigationKey: navigationKey,
              initialRoute: '/',
              routes: {
                '/': (context) => const PageOne(),
                '/two': (context) => const PageTwo(),
                '/three': (context) => const PageThree(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigationKey;
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  const NestedNavigator({
    Key? key,
    required this.navigationKey,
    required this.initialRoute,
    required this.routes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigationKey,
        initialRoute: initialRoute,
        onGenerateRoute: (RouteSettings routeSettings) {
          WidgetBuilder builder = routes[routeSettings.name]!;
          if (routeSettings.name == '/') {
            return PageRouteBuilder(
              pageBuilder: (context, __, ___) => builder(context),
              settings: routeSettings,
            );
          } else {
            return MaterialPageRoute(
              builder: builder,
              settings: routeSettings,
            );
          }
        },
      ),
      onWillPop: () {
        if (navigationKey.currentState?.canPop() ?? false) {
          navigationKey.currentState!.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page one'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/two');
              },
              child: const Text('go page two'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page two'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/three');
              },
              child: const Text('go page three'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('back'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page three'),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('back'),
            ),
          ],
        ),
      ),
    );
  }
}
