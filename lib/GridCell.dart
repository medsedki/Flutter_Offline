import 'package:flutter/material.dart';

import 'models/album.dart';

class GridCell extends StatelessWidget {
  //Add the Update and Delete buttons function as Constructor Parameter
  //const GridCell(this.album);
  const GridCell(this.album, this.updateFunction, this.deleteFunction);

  @required
  final Album album;
  final Function updateFunction;
  final Function deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://via.placeholder.com/600/92c952"),
                //image: Icon(Icons.image),
                fit: BoxFit.cover),
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '${album.title}',
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '${album.id}', //show the album id
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //Add two more buttons for Update and Delete
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    color: Colors.green,
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      album.title = '${album.id} Updated';
                      updateFunction(album);
                    },
                  ),
                  FlatButton(
                    color: Colors.red,
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      album.title = '${album.id} Deleted';
                      deleteFunction(album.id);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
