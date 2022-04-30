import 'package:flutter/material.dart';
import 'game_logic.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = 'X';
  bool gameOver = false;
  Game game = Game();
  int turn = 0;
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard()!;
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Its ${lastValue} turn'.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardLength ~/ 3,
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(
                Game.boardLength,
                (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);
                                if (gameOver) {
                                  result = "$lastValue is the Winner";
                                } else if (!gameOver && turn == 9) {
                                  result = "Its a Draw";
                                  gameOver = true;
                                }
                                if (lastValue == "X")
                                  lastValue = "O";
                                else
                                  lastValue = "X";
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            result,
            style: TextStyle(
              color: Colors.white,
              fontSize: 54.0,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                game.board = Game.initGameBoard()!;
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: Icon(Icons.replay),
            label: Text("Repeat the Game"),
          ),
        ],
      ),
    );
  }
}
