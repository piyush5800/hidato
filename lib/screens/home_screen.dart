import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hidato/components/my_flutter_app_icons.dart';
import 'package:hidato/components/Difficulty.dart';
import 'package:provider/provider.dart';
import 'package:hidato/data/current_data.dart';

DifficultyManage diffManage = DifficultyManage();
int level = 0;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double opacityLevel = 1.0;
  void increment() {
    setState(() {
      diffManage.nextDiff();
    });
  }

  void decrement() {
    setState(() {
      diffManage.prevDiff();
    });
  }

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void levelHandler() async {
    _changeOpacity();
    //Set the level value to 0 i.e. first level
    Provider.of<CurrentData>(context, listen: false).setLevel(level);
    //Set the difficulty of the game
    Provider.of<CurrentData>(context, listen: false)
        .setDifficulty(diffManage.getQuestionText());
    //get the level screen (level =0 for level 1) and get in return the current level
    var returnedLevel = await Navigator.pushNamed(context, '/puzzle');

    //Handling Codes
    //-1 for when exit is pressed
    //-2 for when a level is successfully completed
    //-3 for when solution button is pressed
    //>=0 for level rendering
    while (returnedLevel != -1) {
      if (returnedLevel == -2) {
        //Handles the case when the level is completed
        returnedLevel = await Navigator.pushNamed(context, '/levelComplete');
        if (returnedLevel == -1) {
          //handles the case when return to home screen is pressed on level complete
          break;
        }
      }
      if (returnedLevel == -3) {
        //Handles the case when the solution button is pressed
        returnedLevel = await Navigator.pushNamed(context, '/solution');
        if (returnedLevel == -1) {
          //handles the case when return to home screen is pressed on level complete
          break;
        }
      }
      //If the returned level is not -1, get the level of returned level
      level = returnedLevel;
      Provider.of<CurrentData>(context, listen: false).setLevel(level);
      //push the new level
      returnedLevel = await Navigator.pushNamed(context, '/puzzle');
    }
    //Handles the case when the back button is pressed
    if (returnedLevel == -1) {
      level = 0;
      _changeOpacity();
    }
  }

  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacityLevel,
      duration: Duration(milliseconds: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.0,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(MyFlutterApp.music),
                        iconSize: 40.0,
                      ),
                    ),
                    Opacity(
                      opacity: 0.0,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(MyFlutterApp.speaker),
                        iconSize: 40.0,
                      ),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: IconButton(
                  onPressed: null,
                  icon: Icon(MyFlutterApp.remove_ads),
                  iconSize: 40.0,
                ),
              ),
            ],
          ),
          Icon(
            MyFlutterApp.Hidato,
            size: 250.0,
          ),
          Text(
            "HIDATO",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10.0,
            width: 150.0,
            child: Divider(
              thickness: 2.0,
              color: Colors.black54,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                "DIFFICULTY",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child: IconButton(
                      onPressed: diffManage.getCorrectAnswer() == 1
                          ? null
                          : () {
                              decrement();
                            },
                      icon: Icon(Icons.arrow_left),
                      iconSize: 50.0,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        diffManage.getQuestionText(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: IconButton(
                      onPressed: diffManage.getCorrectAnswer() == 5
                          ? null
                          : () {
                              increment();
                            },
                      icon: Icon(Icons.arrow_right),
                      iconSize: 50.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlineButton(
                  child: Text(
                    'New Game',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  shape: StadiumBorder(),
                  borderSide: BorderSide(width: 2),
                  highlightedBorderColor: Colors.black54,
                  onPressed: () => levelHandler(),
                ),
                OutlineButton(
                  onPressed: () {},
                  child: Text(
                    'Resume',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  shape: StadiumBorder(),
                  borderSide: BorderSide(width: 2),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(MyFlutterApp.gear),
                    iconSize: 40.0,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(MyFlutterApp.paint),
                      iconSize: 40.0,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    onPressed: null,
                    icon: Icon(MyFlutterApp.information),
                    iconSize: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
