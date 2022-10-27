// import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

// void main() {
//   Bloc.observer = SimpleBlocObserver();
//   CounterCubit(0)
//     ..increment()
//     ..close();
// }

///////
abstract class CounterEvent {}

class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>(
      (event, emit) {
        emit(state + 1);
      },
    );
  }

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

// Future<void> main() async {
//   final Bloc bloc = CounterBloc();
//   final StreamSubscription subscription = bloc.stream.listen((event) {
//     print(event);
//   });

//   bloc.add(CounterIncrementPressed());
//   Future.delayed(Duration(seconds: 1));
//   await subscription.cancel();
//   await bloc.close();
// }
