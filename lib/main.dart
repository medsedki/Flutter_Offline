import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Offline Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Test Connexion"),
        ),
        //the Offline Builder test
        body: Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivityResult,
                  Widget child) {
                final bool connected = connectivityResult !=
                    ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      height: 28.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: connected ? null : Colors.red,
                        child: connected ? null : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("OFFLINE",
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                            SizedBox(
                              width: 8.0,
                            ),
                            SizedBox(
                              width: 12.0,
                              height: 12.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
              child: Center(
                child: Text("ONLINE Or OFFLINE"),
              ),
            );
          },

        ),
        /*body: Center(
          child: Text('Test Offline'),
        ),*/
      ),
    );
  }
}

// Offline
// 3part compsant
// par example Calender kifech
// bleutooth
// Scan code a barre
// Facebook Authentification

//https://jsonplaceholder.typicode.com/posts
