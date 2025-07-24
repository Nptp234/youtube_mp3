import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsWaiting extends StateNotifier<bool>{
  IsWaiting() : super(false);
  void change(bool val) => state = val;
}

final waitingProvider = StateNotifierProvider<IsWaiting, bool>(
  (ref){
    return IsWaiting();
  }
);