import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_memory_game/model/board_item_model.dart';
import 'package:flutter_memory_game/widgets/board_item.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  //Level
  //1 : 6 items
  //2 : 8 items
  //3 : 10 items
  //4 : 12 items
  int numberItem = 8; // 8 numberItem akan membuat 16 items (karena pair)

  int currentScore = 0;

  String status;

  //berisi semua board item yang ada di puzzle
  List<BoardItemModel> boardPuzzle = [];

  //berisi board item yang dipilih, tetapi belum complete
  List<BoardItemModel> chosenItem = [];
  Timer timeDelayed;

  @override
  void initState() {
    setUpBoard();
    setState(() {
      status = "Ketuk Play untuk mulai bermain";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Ojo Lali"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text("Score: $currentScore/${numberItem * 100}")),
            GridView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
              children: List.generate(boardPuzzle.length, (index) {
                return BoardItem(
                  itemModel: boardPuzzle[index],
                  onTap: () {
                    onItemTap(index);
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text('Play', style: TextStyle(color: Colors.white)),
              color: Colors.purple,
              onPressed: () => onPlay(),
            ),
            SizedBox(height: 20),
            Text(status),
          ]),
        ),
      ),
    );
  }

  void onItemTap(int index) {
    var selectedItem = boardPuzzle[index];
    if (!selectedItem.isCompleted && !selectedItem.isRevealed) {
      setState(() {
        selectedItem.setRevealed(true);
        //kalau lebih dari 2 kita tutup dulu yang lama
        closePreviousChosenItem();
        chosenItem.add(selectedItem);
        if (chosenItem.length == 2) {
          //jika 2 item telah dipilih
          if (chosenItem[0].imagePath == chosenItem[1].imagePath) {
            //saat complete
            onItemCompleted();
          } else {
            if (timeDelayed != null) {
              timeDelayed.cancel();
            }
            timeDelayed = Timer(Duration(seconds: 2), () {
              //tutup yang terbuka setelah 2 detik
              closePreviousChosenItem();
            });
            // and later, before the timer goes off...

          }
        }
      });
    }
  }

  void onItemCompleted() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setCompleted(true);
        chosenItem[1].setCompleted(true);
        chosenItem.clear();

        //score
        currentScore += 100;
        if (currentScore == numberItem * 100) {
          onCompleted();
        }
      });
    }
  }

  void onCompleted() {
    print("oncompleted");
    setState(() {
      status = "Permainan Selesai, Ketuk play untuk bermain lagi...";
    });
  }

  void closePreviousChosenItem() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setRevealed(false);
        chosenItem[1].setRevealed(false);
        chosenItem.clear();
      });
    }
  }

  void setUpBoard() {
    List<BoardItemModel> allItem = [];
    for (int x = 1; x < 40; x++) {
      allItem.add(BoardItemModel(imagePath: "assets/$x.webp"));
    }
    //clear choosenItem
    boardPuzzle = [];

    //Acak allItem, dan ambil numberItem teratas (misal 8 teratas)
    var randomItem = (allItem..shuffle()).take(numberItem);

    //tambahkan 2x karena item nya berpasangan.
    boardPuzzle.addAll(randomItem);
    boardPuzzle.addAll(randomItem.map((item) => item.copy()).toList());
    setState(() {
      boardPuzzle.shuffle();
      currentScore = 0;
      status = "Temukan pasangan gambar !";
    });
  }

  void onPlay() {
    setUpBoard();
    //reveal for first 3 sec

    boardPuzzle.forEach((element) {
      setState(() {
        element.isRevealed = true;
          status = "Ingat gambarnya dalam 3 detik...";
      });
    });

    if (timeDelayed != null) {
      timeDelayed.cancel();
    }
    timeDelayed = Timer(Duration(seconds: 3), () {
      boardPuzzle.forEach((element) {
        setState(() {
          element.isRevealed = false;
          status = "Temukan pasangan gambar !";
        });
      });
    });
  }
}
