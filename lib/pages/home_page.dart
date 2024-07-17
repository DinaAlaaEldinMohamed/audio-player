import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:lec1/helpers/constants.dart';
import 'package:lec1/helpers/helper.dart';
import 'package:lec1/widgets/audio_list_tile.dart';
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
            album: 'under water',
            artist: 'artist 1')),
    Audio('assets/audio/2.mp3',
        metas: Metas(
            title: 'ambient-piano',
            image: const MetasImage.network(
                'https://cdn.pixabay.com/audio/2023/09/06/15-01-04-482_200x200.jpg'),
            album: 'piano',
            artist: 'artist 2')),
    Audio('assets/audio/3.mp3',
        metas: Metas(
            title: 'deep-strange-whoosh',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'deep strange',
            artist: 'artist 3')),
    Audio('assets/audio/4.mp3',
        metas: Metas(
            title: 'something-strange',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'deep strange',
            artist: 'artist 4')),
    Audio('assets/audio/s5.mp3',
        metas: Metas(
            title: 'sample-5',
            image: const MetasImage.asset('assets/music.jpg'),
            album: 'sample',
            artist: 'artist 5')),
  ];
  double _currentVolume = 0.0;
  double playSpeedEx = 1.0;
  @override
  void initState() {
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
      assetsAudioPlayer.playSpeed.listen((event) {
        print('>>>>>${event}');
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
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            snapshot.data?.current?.audio.audio.metas.title ==
                                    ''
                                ? 'plase play song'
                                : snapshot.data?.current?.audio.audio.metas
                                        .title ??
                                    '',
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
                                  onPressed: snapshot.data?.current?.index ==
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
                                      .toDouble() ??
                                  0.0,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setStateEx) {
                                            // Use StatefulBuilder to manage the state of the slider
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Slider(
                                                    value: _currentVolume,
                                                    min: AssetsAudioPlayer
                                                        .minVolume,
                                                    max: AssetsAudioPlayer
                                                        .maxVolume,
                                                    onChanged: (newValue) {
                                                      if (newValue < 0.0) {
                                                        _currentVolume = 0.0;
                                                      } else if (newValue >
                                                          1.0) {
                                                        _currentVolume = 1.0;
                                                      } else {
                                                        _currentVolume =
                                                            newValue;
                                                      }
                                                      assetsAudioPlayer
                                                          .setVolume(
                                                              _currentVolume);
                                                      setStateEx(() {});
                                                    },
                                                    activeColor: Colors.blue,
                                                    inactiveColor: Colors.grey,
                                                  ),
                                                  Text(
                                                      'Volume: ${(_currentVolume * 100).roundToDouble()}%'),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.volume_up)),
                              Text(
                                '${convertSeconds(sliderValue)}  /  ${convertSeconds(snapshot.data?.duration.inSeconds ?? 0)}',
                                style: TextStyle(
                                  color: purpleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Show a dialog or bottom sheet to select playback speed
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                          builder: (context, setStateEx) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Select Playback Speed'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SegmentedButton(
                                                  multiSelectionEnabled: false,
                                                  onSelectionChanged: (values) {
                                                    playSpeedEx =
                                                        values.first.toDouble();
                                                    assetsAudioPlayer
                                                        .setPlaySpeed(
                                                            playSpeedEx);
                                                    setStateEx(() {});
                                                  },
                                                  segments: const [
                                                    ButtonSegment(
                                                      icon: Text('1X'),
                                                      value: 1.0,
                                                    ),
                                                    ButtonSegment(
                                                      icon: Text('2X'),
                                                      value: 4.0,
                                                    ),
                                                    ButtonSegment(
                                                      icon: Text('3X'),
                                                      value: 8.0,
                                                    ),
                                                    ButtonSegment(
                                                      icon: Text('4X'),
                                                      value: 16.0,
                                                    ),
                                                  ],
                                                  selected: {
                                                    playSpeedEx
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                },
                                icon: Icon(Icons.speed),
                              ),
                            ],
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
                                            AudioListtile(audio: audio))
                                        .toList(),
                                  ),
                                ),
                              ),
                              Container(
                                  width: width,
                                  color: lightBlueColor,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: audios
                                          .map((audio) =>
                                              buildListTile(audio, 'album'))
                                          .toList(),
                                    ),
                                  )),
                              Container(
                                  width: width,
                                  color: lightPurbleColor,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: audios
                                          .map((audio) =>
                                              buildListTile(audio, 'artist'))
                                          .toList(),
                                    ),
                                  )),
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

  Widget buildListTile(Audio audio, String type) {
    if (type == 'artist') {
      return ListTile(
        title: Text(audio.metas.artist ?? 'undefind artist'),
        onTap: () async {},
      );
    } else {
      return ListTile(
        title: Text(audio.metas.album ?? 'undefind album'),
        onTap: () async {},
      );
    }
  }
}
