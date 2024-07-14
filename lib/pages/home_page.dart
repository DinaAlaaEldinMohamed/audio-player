import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:lec1/helpers/constants.dart';
import 'package:lec1/widgets/tab_bar_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sliderValue = 0;
  final assetsAudioPlayer = AssetsAudioPlayer();

  final audios = <Audio>[
    Audio('assets/audio/1.mp3',
        metas: Metas(
            title: 'large-underwater',
            image: const MetasImage.network(
                'https://cdn.pixabay.com/audio/2024/02/08/21-07-20-860_200x200.png'),
            album: 'under water')),
    Audio('assets/audio/2.mp3',
        metas: Metas(
            title: 'ambient-piano',
            image: const MetasImage.network(
                'https://cdn.pixabay.com/audio/2023/09/06/15-01-04-482_200x200.jpg'),
            album: 'piano')),
    Audio('assets/audio/3.mp3',
        metas: Metas(
            title: 'deep-strange-whoosh',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'deep strange')),
    Audio('assets/audio/4.mp3',
        metas: Metas(
            title: 'something-strange',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'deep strange')),
    Audio('assets/audio/s5.mp3',
        metas: Metas(
            title: 'sample-5',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'sample')),
  ];

  //create a new player
  @override
  void initState() {
    print('iniiiit');
    openPlayer();
    super.initState();
  }

  openPlayer() async {
    try {
      await assetsAudioPlayer.open(
          Playlist(
            audios: audios,
          ),
          autoStart: false,
          showNotification: true);
      print('playing:${assetsAudioPlayer.isPlaying.value}');
      assetsAudioPlayer.currentPosition.listen((event) {
      sliderValue = event.inSeconds;
    });
      setState(() {});
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Music Player')),
      body: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    color: const Color(0xffE7DDFF),
                    width: 400,
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            snapshot.data?.current?.audio.audio.metas.title== ''
                                ? 'plase play song'
                                : snapshot.data?.current?.audio.audio.metas.title??'',
                            style: TextStyle(color: purpleColor, fontSize: 18),
                          ),
                          // Playback controls
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  color: purpleColor,
                                  icon: const Icon(Icons.skip_previous),
                                  onPressed: snapshot.data?.current?.index == 0
                                            ? null
                                            : () {
                                                assetsAudioPlayer.previous();
                                              },
                                  
                                ),
                                IconButton(
                                  icon: Icon(
                                    size: 50,
                                    color: purpleColor,
                                    assetsAudioPlayer.isPlaying.value
                                        ? Icons.pause_circle_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                                  onPressed: () async {
                                    if (assetsAudioPlayer.isPlaying.value ==
                                        true) {
                                      assetsAudioPlayer.pause();
                                    } else {
                                      await assetsAudioPlayer.play();
                                    }
                                  },
                                ),
                                IconButton(
                                  color: purpleColor,
                                  icon: const Icon(
                                    Icons.skip_next,
                                  ),
                                  onPressed: 
                                     snapshot.data?.current?.index ==
                                            (assetsAudioPlayer.playlist?.audios
                                                        .length ??
                                                    0) -
                                                1
                                        ? null
                                        : () {
                                            assetsAudioPlayer.next();
                                          },
                                 // },
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //     '00:00/${assetsAudioPlayer.current.value?.audio.duration}'),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                trackHeight: 0.5,
                                thumbShape: SliderComponentShape.noThumb,
                                inactiveTrackColor: Colors.black26),
                            child: Slider(
                              min: 0,
                              max: snapshot.data?.duration.inSeconds
                                      .toDouble() ??  0.0,
                              value: sliderValue.toDouble(),
                              onChanged: (value) {
                                sliderValue = value.toInt();
                                setState(() {});
                              },
                                onChangeEnd: (value) async {
                                await assetsAudioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(tabs: [
                            Tab(
                                child: TabBarTitle(
                              title: 'Playlist',
                              icon: Icons.playlist_play,
                            )),
                            Tab(
                              child: TabBarTitle(
                                title: 'Albums',
                                icon: Icons.album_rounded,
                              ),
                            ),
                            Tab(
                              child: TabBarTitle(
                                title: 'Artist',
                                icon: Icons.person_outlined,
                              ),
                            )
                          ]),
                          Expanded(
                            child: TabBarView(children: [
                              Container(
                                //padding: EdgeInsets.all(16),
                                //  alignment: Alignment.center,
                                width: width,
                                color: greyColor,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: audios
                                        .map((audio) =>
                                            buildAudioListTile(audio))
                                        .toList(),
                                  ),
                                ),
                              ),
                              Container(
                                child: const Text('ALBUM'),
                              ),
                              Container(
                                child: const Text('ARTIST'),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> playAudio(Audio audio) async {
    try {
      await assetsAudioPlayer.open(audio, autoStart: true);
      //  assetsAudioPlayer.play();
      print(
          'audio title:${audio.metas.title}, isplaying :${assetsAudioPlayer.isPlaying.value},audioPath:${audio.path}');
    } catch (e) {
      print('Error playing audio: $e');
    }
    // setState(() {});
  }

  Widget buildAudioListTile(Audio audio) {
    // var audioFileDuration =
    //   assetsAudioPlayer.current.value?.audio.duration.inMilliseconds;
    // print('audioduration:$audioFileDuration');
 // assetsAudioPlayer.open(audio, autoStart: false);
    return ListTile(
      title: Text(audio.metas.title ?? 'song'),
      leading: Text(audio.metas.album?.substring(0, 2).toUpperCase() ?? ''),
      subtitle: Text(audio.metas.album ?? ''),
      trailing:
      
          StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapshot) {
              return  Text(convertSeconds(snapshot.data?.duration.inSeconds??0));
            }
          ), //audioFileDuration?.toString() ?? '0:00s'),
      onTap: () async {
        try {
          await playAudio(audio);
          setState(() {});
        } catch (e) {
          print('error playing audio:$e');
        }
      },
    );
  }

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String second = (seconds % 60).toString();
    return "${minutes.padLeft(2, "0")} : ${second.padLeft(2, "0")}";
  }
}
