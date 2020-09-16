import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'GridCell.dart';
import 'db/DBHelper.dart';
import 'models/album.dart';
import 'models/albums.dart';
import 'service/Services.dart';

void main() {
  //runApp(MyApp());
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false, home: new GridViewDemo()));
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
                  ConnectivityResult connectivityResult, Widget child) {
                final bool connected =
                    connectivityResult != ConnectivityResult.none;
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
                        child: connected
                            ? null
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "OFFLINE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
      ),
    );
  }
}

class GridViewDemo extends StatefulWidget {
  GridViewDemo() : super();

  final String title = "Photos";

  @override
  GridViewDemoState createState() => GridViewDemoState();
}

class GridViewDemoState extends State<GridViewDemo> {
  //
  int counter;
  static Albums albums;
  DBHelper dbHelper;
  bool albumsLoaded;
  String Title; // Title for the AppBar where we will show the progress..
  double percent;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    counter = 0;
    dbHelper = DBHelper();
    albumsLoaded = false;
    Title = widget.title;
    scaffoldKey = GlobalKey();
    percent = 0.0;
  }

  getPhotos() {
    setState(() {
      // We are going to use these variables in the UI later...
      counter = 0;
      albumsLoaded = false;
    });
    Services.getPhotos().then((allAlbums) {
      albums = allAlbums;
      // Now we got all the albums from the Service class...
      // We will insert each album one by one into the Database...

      // On each load, we will truncate the table
      dbHelper.truncateTable().then((value) {
        // Write a recursive function to insert all the albums
        insert(albums.albums[0]);
      });
    });
  }

  insert(Album album) {
    dbHelper.save(album).then((value) {
      counter = counter + 1;

      // We are calculating the percent here on insert of each record..
      // percent from 0 to 1
      // percent from terminate condition for this recursive function
      percent = (counter / albums.albums.length * 100) / 100;

      //terminate condition for the recursive function
      if (counter >= albums.albums.length) {
        // When inserting the done
        setState(() {
          albumsLoaded = true;
          percent = 0.0;
          Title = '${widget.title}[$counter]';
        });
        return;
      }
      setState(() {
        Title = "Inserting...$counter";
      });
      Album a = albums.albums[counter];
      insert(a);
    });
  }

  gridview(AsyncSnapshot<Albums> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data.albums.map((album) {
          return GridTile(
            child: GridCell(album, update, delete),
          );
        }).toList(),
      ),
    );
  }

  // Update Function
  update(Album album) {
    // We are updating the album title on each update
    dbHelper.update(album).then((updtVal) {
      showSnackBar('Updated ${album.id}');
      refresh();
    });
  }

  // Delete Function
  //delete(num id) {
  //delete(String id) {
  delete(int id) {
    dbHelper.delete(id).then((delVal) {
      showSnackBar('Deleted $id');
      refresh();
    });
  }

  // Method to refresh the List after the DB Operations
  refresh() {
    dbHelper.getAlbums().then((allAlbums) {
      setState(() {
        albums = allAlbums;
        counter = albums.albums.length;
        Title = '${widget.title} [$counter]'; // updating the title
      });
    });
  }

  // Show a Snackbar
  showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(Title),
        ),
        // Add action buttons in the AppBar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              getPhotos();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          albumsLoaded
              ? Flexible(
                  child: FutureBuilder<Albums>(
                    future: dbHelper.getAlbums(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        return gridview(snapshot);
                      }
                      //if still loading return an empty container
                      return Container();
                    },
                  ),
                )
              : LinearProgressIndicator(
                  value: percent,
                ),
        ],
      ),
    );
  }
}
