import 'package:bsq/cubit/bsq_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
/*
  Future<Widget> _getWidget() async {
    return null; //loadAsset();
  }
*/
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BsqCubit(),
      child: MaterialApp(
        title: 'BSQ',
        home: Scaffold(
          body: Center(
            child: BlocBuilder<BsqCubit, BsqState>(builder: (context, state) {
              if (state is BsqLoaded) {
                return state.widget;
              } else if (state is BsqFailed) {
                return const Icon(Icons.error);
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ),
      ),
    );
  }
}
