import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';
import 'package:puzzlemath/blocs/camera/camera_states.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final num _throttle;
  num _busySince = 0;

  CameraBloc(this._throttle) : super(CameraUninitialized());

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is InitializeCamera) {
      yield* _mapInitializeCameraToState();
    } else if (event is TakePicture) {
      yield* _mapTakePictureToState(event);
    }
  }

  Stream<CameraState> _mapInitializeCameraToState() async* {
    yield CameraReady();
  }

  Stream<CameraState> _mapTakePictureToState(TakePicture event) async* {
    if (state is CameraInitialized) {
      final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
      if (currentMilliseconds - _busySince > _throttle) {
        yield CameraBusy(event.image);
      }
    }
  }
}
