import 'package:narai/bloc/bloc.dart';

abstract class BlocProvider {
  final Map<Type, Bloc> states = new Map();

  BlocProvider([Iterable<Bloc> blocs]) {
    if(blocs != null) {
      blocs.forEach((bloc) => this.register(bloc));
    }
  }

  void register<T extends Bloc>(T instance) {
    print("registering $T - $instance");
    if(!this.states.containsKey(instance.runtimeType)) {
      this.states[instance.runtimeType] = instance;
    } else {
      throw "Bloc Type already registered!";
    }
  }

  T get<T extends Bloc>() {
    if(this.states.containsKey(T)) {
      return this.states[T] as T;
    } else {
      throw "Bloc Type not registered!";
    }
  }
}