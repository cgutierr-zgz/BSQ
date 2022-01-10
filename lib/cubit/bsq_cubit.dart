import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'bsq_state.dart';

class BsqCubit extends Cubit<BsqState> {
  BsqCubit() : super(const BsqInitial()) {
    if (state is BsqInitial) startBsq();
  }

  int getInt(int one, int two, int three) {
    int smallint;

    smallint = 0;
    if (one < two) {
      if (one < three) {
        smallint = one;
      } else {
        smallint = three;
      }
    } else if (two > three) {
      smallint = three;
    } else {
      smallint = two;
    }
    return (smallint + 1);
  }

  startBsq() async {
    String map = await rootBundle.loadString('assets/example_file');

    List<String> lines = map.split('\n');
    List<List<int>> matrix = [[]];

    // TODO: Checkear que todas las lineas tengan la misma longitud
    // Converitmos el string en una matriz de 1's y 0's(obs)
    for (int i = 0; i < lines.length; i++) {
      for (int j = 0; j < lines[i].length; j++) {
        matrix.add([]);
        if (lines[i][j] == '.') {
          matrix[i].add(1);
        } else if (lines[i][j] == 'o') {
          matrix[i].add(0);
        } else {
          emit(const BsqFailed()); // TODO: put message
          return;
        }
      }
    }
    sendWidget(matrix);
    // TODO: print/emit each new version, with delay
    // Decompose map
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; i++) {
        if (j != 0 && i != 0) {
          if (matrix[i][j] >= 1 &&
              (matrix[i][j] >= 1 &&
                  matrix[i][j - 1] >= 1 &&
                  matrix[i - 1][j] >= 1 &&
                  matrix[i - 1][j - 1] >= 1)) {
            matrix[i][j] = getInt(
              matrix[i - 1][j],
              matrix[i][j - 1],
              matrix[i - 1][j - 1],
            );
          }
        }
      }
    }
    sendWidget(matrix);

    // TODO:  etc...ft_newtab(mapinfo, tabl);
  }

  void sendWidget(List<List<int>> matrix) async {
    emit(const BsqInitial());
    List<Widget> widgets = [];
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        widgets.add(
          Text(matrix[i][j].toString()),
          /*Container(
            color: matrix[i][j] == 1 ? Colors.grey.shade300 : Colors.grey,
            width: 5,
            height: 5,
            margin: const EdgeInsets.all(1),
          ),*/
        );
      }
    }
    Widget gridView = GridView.count(
      shrinkWrap: true,
      crossAxisCount: matrix[0].length,
      children: widgets,
    );

    await Future.delayed(Duration(milliseconds: 50));
    emit(BsqLoaded(widget: gridView));
  }
}
