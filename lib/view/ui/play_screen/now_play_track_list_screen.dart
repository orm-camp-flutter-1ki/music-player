import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/audio_part/audio_event.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../audio_part/audio_bar.dart';
import '../song_part/detail_song_menu.dart';
import '../song_part/song_tile.dart';

class NowPlayTrackListScreen extends StatelessWidget {
  const NowPlayTrackListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: Color(state.artColor).withOpacity(0.6),
      body: Column(
        children: [
          SafeArea(
              child: AudioBar(
            audioState: state,
            progressBarState: viewModel.progressNotifier,
            callback: (event) {
              switch (event) {
                case PreviousPlay():
                  viewModel.previousPlay();
                case ClickPlayButton():
                  viewModel.clickPlayButton();
                case Seek():
                  viewModel.seek(event.duration);
                case NextPlay():
                  viewModel.nextPlay();
                case StopMusic():
                  viewModel.stopMusic();
              }
            },
          )),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.grey.withOpacity(0.6),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.grey,
                        ),
                        width: 30,
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'now track list',
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    children: state.playList.asMap().entries.map((map) {
                      int idx = map.key;
                      final e = map.value;
                      final bool isEqual = viewModel.state.currentIndex == idx;
                      return GestureDetector(
                          onLongPress: () {
                            final myModel = Provider.of<AudioViewModel>(context,
                                listen: false);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.3,
                                  builder: (context, scrollController) =>
                                      ChangeNotifierProvider.value(
                                    value: myModel,
                                    child: DetailSongMenu(song: e),
                                  ),
                                );
                              },
                            );
                          },
                          onTap: () {
                            if (isEqual) {
                              return;
                            }
                            viewModel.clickPlayListSong(idx: idx);
                          },
                          child: SongTile(song: e, isEqual: isEqual));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
