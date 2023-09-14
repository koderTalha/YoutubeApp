import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:youutbeapp/Utilis/constants.dart';

import '../Models/channel_info.dart';
import '../Models/video_list.dart';

class Services {
  static const channelId = "UChtLmGMVNnOnUCQJVudCzMQ";
  static const baseurl = "www.googleapis.com";

  static Future<Channelinfo> getchannelinfo() async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': channelId,
      'key': Constants.Api_Key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    Uri uri = Uri.https(baseurl, '/youtube/v3/channels', parameters);

    Response response = await http.get(uri, headers: headers);

    Channelinfo channelinfo = channelinfoFromJson(response.body);
    return channelinfo;
  }

  static Future<Videolist> getvideolist({required String pagetoken,required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': pagetoken,
      'key': Constants.Api_Key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(baseurl, '/youtube/v3/playlistItems', parameters);
    Response response = await http.get(uri, headers: headers);
    Videolist videolist = videolistFromJson(response.body);
    print(response.body);
    return videolist;
  }
}
