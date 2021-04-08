import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:bpbug/bp_con.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoBox extends StatefulWidget {
  const VideoBox();
  @override
  _VideoBoxState createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  BetterPlayerController videoCon;
  File tmpVideo;

  @override
  void initState() {
    super.initState();
    pickVideo();
  }

  @override
  void dispose() {
    // tmpVideo?.delete();
    videoCon?.dispose();
    super.dispose();
  }

  pickVideo() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        // allowMultiple: true,
        type: FileType.any
        // allowCompression: true,
        );
    if (result != null) {
      var file = result.files.first;
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      var path = file.path;
      // IOS has to copy a file to play
      if (Platform.isIOS) {
        final doc = await getApplicationDocumentsDirectory();
        var dir = Directory(doc.path + '/tmp');
        if (!dir.existsSync()) {
          dir.createSync();
        }
        tmpVideo = await File(file.path).copy(
            dir.path + '/tmpVideo' + getSuffix(file.path));
        FilePicker.platform.clearTemporaryFiles();
        path = tmpVideo.path;
      }
      if (videoCon == null) {
        videoCon = bpCon(path);
      } else {
        await videoCon.setupDataSource(BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          path,
        ));
      }
      setState(() {});
      print('video.path   $path   ');
    } else {
      print('no file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pretty boy'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AspectRatio(
              aspectRatio: 1.8,
              child: Stack(
                children: [
                  videoCon != null
                      ? BetterPlayer(
                          controller: videoCon,
                        )
                      : Container(
                          color: Colors.black,
                        ),
                  Positioned(
                      left: 120,
                      top: 15,
                      child: ElevatedButton(
                          onPressed: pickVideo, child: Text('choose video')))
                ],
              )),
        ],
      ),
    );
  }
}
getSuffix(path) => RegExp(r"\.[^\.]+$").stringMatch(path);