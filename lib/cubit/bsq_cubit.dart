import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'bsq_state.dart';

Color darken(Color color, [double amount = .1]) {
//amount = 0.0;
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

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

    // Todo: Checkear que todas las lineas tengan la misma longitud
    // Converitmos el string en una matriz de 1's y 0's(obs)
    for (int i = 0; i < lines.length; i++) {
      for (int j = 0; j < lines[i].length; j++) {
        matrix.add([]);
        if (lines[i][j] == '.') {
          matrix[i].add(1);
        } else if (lines[i][j] == 'o') {
          matrix[i].add(0);
        } else {
          emit(const BsqFailed()); // Todo: put message
          return;
        }
      }
    }
    sendWidget(matrix);
    // Todo: print/emit each new version, with delay
    // Decompose map
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (i != 0 &&
            j != 0 &&
            matrix[i][j] >= 1 &&
            (matrix[i][j] >= 1 &&
                matrix[i][j - 1] >= 1 &&
                matrix[i - 1][j] >= 1 &&
                matrix[i - 1][j - 1] >= 1)) {
          matrix[i][j] = getInt(
            matrix[i - 1][j],
            matrix[i][j - 1],
            matrix[i - 1][j - 1],
          );
          await Future.delayed(const Duration(microseconds:1));
          sendWidget(matrix);
        }
      }
    }

    // Todo:  etc...ft_newtab(mapinfo, matrix);

    int maxnumx = 0;
    int maxnumy = 0;
    int bignum = 0;

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] > bignum) {
          bignum = matrix[i][j];
          maxnumx = i;
          maxnumy = j;
        }
      }
    }

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] == 0) {
          //    print('0');
        } else if (i <= maxnumx &&
            j <= maxnumy &&
            i > (maxnumx - bignum) &&
            j > (maxnumy - bignum))
          matrix[i][j] = -1; //   print('X');
        else {
          //print(' ');
        }
          await Future.delayed(const Duration(microseconds:1));
        sendWidget(matrix);
      }
    }
  }

  void sendWidget(List<List<int>> matrix) async {
    emit(const BsqInitial());
    List<Widget> widgets = [];
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < matrix[i].length; j++) {
        widgets.add(
          //Text(matrix[i][j].toString())

          Container(
            color: matrix[i][j] == 0
                ? Colors.grey
                : matrix[i][j] == -1
                    ? Colors.red
                    : darken(Colors.greenAccent, 1 / (matrix[i][j]).toDouble()),
            width: 5,
            height: 5,
            margin: const EdgeInsets.all(1),
          ),
        );
      }
    }
    Widget gridView = GridView.count(
      shrinkWrap: true,
      crossAxisCount: matrix[0].length,
      children: widgets,
    );

    emit(BsqLoaded(widget: gridView));
  }
}
