
import '../../../repository/play_list_repository.dart';
import '../interface/remove_custom_play_list.dart';

class RemoveCustomPlayListImpl implements RemoveCustomPlayList{
  final PlayListRepository _playListRepository;

  const RemoveCustomPlayListImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  void execute({required int key}) {
    _playListRepository.box.delete(key);
  }

}