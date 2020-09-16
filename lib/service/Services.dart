import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/album.dart';
import '../models/albums.dart';

class Services {
  //Add the list
  static List<Album> albums;

  // the service URL
  static const String url = "https://jsonplaceholder.typicode.com/photos";

  static Future<Albums> getPhotos() async {
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        Albums albums = parsePhotos(response.body);
        return albums;
      } else {
        Albums albums = new Albums();
        albums.albums = [];
        return albums; //returning empty album list
        // Handle this as you want..
      }
    } catch (e) {
      //return Albums();
      Albums albums = new Albums();
      albums.albums = [];
      return albums;
    }
  }

  static Albums parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Album> albums =
        parsed.map<Album>((json) => Album.fromJson(json)).toList();
    Albums a = new Albums();
    a.albums = albums;
    return a;
  }
}
