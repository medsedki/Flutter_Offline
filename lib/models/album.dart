import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
    Album();

    num userId;
    num id;
    String title;
    String body;
    
    factory Album.fromJson(Map<String,dynamic> json) => _$AlbumFromJson(json);
    Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
