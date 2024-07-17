import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:lec1/helpers/helper.dart';

class AudioListtile extends StatefulWidget {
  final Audio audio;
  const AudioListtile({required this.audio, super.key});

  @override
  State<AudioListtile> createState() => _AudioListtileState();
}

class _AudioListtileState extends State<AudioListtile> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.audio.metas.title ?? 'song'),
      leading:
          Text(widget.audio.metas.album?.substring(0, 2).toUpperCase() ?? ''),
      subtitle: Text(widget.audio.metas.album ?? ''),
      trailing: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (context, snapshot) {
            return Text(convertSeconds(snapshot.data?.duration.inSeconds ?? 0));
          }),
      onTap: () async {
        try {
          await playAudio(widget.audio);
          setState(() {});
        } catch (e) {
          print('error playing audio:$e');
        }
      },
    );
  }

  Future<void> playAudio(Audio audio) async {
    try {
      await assetsAudioPlayer.open(audio, autoStart: true);
      print(
          'audio title:${audio.metas.title}, isplaying :${assetsAudioPlayer.isPlaying.value},audioPath:${audio.path}');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}
