import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youutbeapp/Models/channel_info.dart';
import 'package:youutbeapp/Models/video_list.dart';
import 'package:youutbeapp/Screens/video_screen.dart';
import 'package:youutbeapp/Utilis/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Channelinfo _channelinfo;
  late Videolist _videolist;
  late Item _item;
  bool _loading = true;
  late String _playlistId;
  late String _nextpagetoken;
  final ScrollController _scrollControllersexy = ScrollController();



  @override
  void initState() {
    _loading = true;
    _nextpagetoken ='';
   _videolist = Videolist();
   _videolist.videos = [];
   _getChannelinfo();
    super.initState();
  }


  _getChannelinfo()async{
    _channelinfo =  await Services.getchannelinfo();
    _item = _channelinfo.items[0];
    _playlistId =  _item.contentDetails.relatedPlaylists.uploads;
    await _loadVideolist();
    setState(() {
      _loading =false;
    });
  }

  _loadVideolist()async{
    Videolist tempvideoList  =  await Services.getvideolist(
        playlistId:_playlistId,
        pagetoken: _nextpagetoken );
    _nextpagetoken = tempvideoList.nextPageToken!;
    _videolist.videos!.addAll(tempvideoList.videos as Iterable<VideoItem>);
    // print('video Id ${_videolist.videos!.length}');
    // print('pagetoken ${_nextpagetoken}');
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutortech"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildInfoView(),
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollNotification notification){
                  if(notification.metrics.pixels == notification.metrics.maxScrollExtent){
                    _loadVideolist();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollControllersexy,
                  itemCount: _videolist.videos!.length,
                  itemBuilder: (context,index){
                    VideoItem videoitem = _videolist.videos![index];
                    return InkWell(
                      onTap: ()async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoItem: videoitem)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: videoitem.video.thumbnails.thumbnailsDefault.url,
                            ),
                            const SizedBox(width: 20,),
                            Flexible(child: Text(videoitem.video.title)),
                            const SizedBox(width: 20,),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
  _buildInfoView(){
    return _loading? const Column(
      children: [
        Center(child: CircularProgressIndicator()),
      ],
    ) :
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                _item.snippet.thumbnails.medium.url,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _item.snippet.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              _item.statistics.videoCount,
            ),
            const SizedBox(width: 8,),
          ],
        ),
      ),
    );
  }
}
