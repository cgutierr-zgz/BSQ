part of 'bsq_cubit.dart';

abstract class BsqState extends Equatable{
  const BsqState();

  @override
  List<Object> get props => [];
}

class BsqInitial extends BsqState {
  const BsqInitial() : super();
}

class BsqLoaded extends BsqState {
  final Widget widget;
  const BsqLoaded({required this.widget}) : super();
}

class BsqFailed extends BsqState {
  const BsqFailed() : super();
}
