import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simple Music App",
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover
          )
        ),
        child: MusicApp(),
      ),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => new _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {

  // INITIALIZER VARIABLE
  List musicList = [
    'Music0.mp3',
    'Music1.mp3',
    'Music2.mp3'
  ];

  List titleList = [
    "We Can't Stop",
    "Home",
    "Berlari Tanpa Kaki"
  ];

  var title = "Home";
  int currentIndex = 1;
  bool isPlayed = false;

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Map titleMap;


  @override
  void initState()
  {
    super.initState();
    initPlayer();
  }

  void initPlayer() {

    titleMap = titleList.asMap();
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });    
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  Widget slider() {
    return Slider(
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
      activeColor: Colors.white,
      inactiveColor: Colors.blueGrey,
    );
  }

  void nextMusic() {
    

    stopMusic();
    if (currentIndex > 1) {
      currentIndex = currentIndex;
    } else {
      currentIndex = currentIndex + 1;
    }      

    title = titleMap[currentIndex];
  }


  void previousMusic() {
    
    stopMusic();
    if (currentIndex < 1) {
      currentIndex = currentIndex;
    } else {
      currentIndex = currentIndex - 1;
    }
    title = titleMap[currentIndex];
  }

  void playMusic() 
  {            
    audioCache.play('Music$currentIndex.mp3');       
    isPlayed = true;
  }

  void stopMusic() 
  {
    // audioPlayer.stop();
    advancedPlayer.pause();
    isPlayed = false;
  }

  Widget topBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      child: Card(      
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(Icons.headset, color: Colors.white),
          title: Text('CURRENT SONG', style: TextStyle(
            letterSpacing: 2.0,
            color: Colors.white
          )),
          trailing: Icon(Icons.favorite_border, color: Colors.white),
          
        ),
      ),
    );
  }

  Widget midRow() {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text('$title', 
              style: TextStyle(
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25.0,
                fontFamily: 'Oxygen'
              )
            ),
            
            Divider(
              color: Colors.transparent,
              thickness: 0.5,
              endIndent: 40.0,
              indent: 40.0,
              height: 20.0,
            ),

            Container(
              padding: EdgeInsets.all(0),

              child: CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage('images/Picture1.jpg'),
                backgroundColor: Colors.transparent,
              )
            ),

            Divider(
              height: 60.0,
              thickness: 0.5,
              endIndent: 40.0,
              indent: 40.0,
              color: Colors.transparent,
            ),

            slider()

          ],
        )
    );
  }

  Widget bottomRow()
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Expanded(
            child: FlatButton(
              onPressed: () {
                setState(() {
                  previousMusic();
                  print('fast rewind!');     
                });
              },
              child:Icon(Icons.fast_rewind, color: Colors.white),
            ),
          ),

          Expanded(
            child: FlatButton(
              onPressed: () {
                setState(() {
                  if(isPlayed == true) stopMusic();
                  else playMusic();
                  print('play, pause!');                                      
                });
              },
              child:
                isPlayed ? 
                  Icon(Icons.pause, color: Colors.white, size: 40.0):  Icon(Icons.play_arrow, color: Colors.white, size: 40.0) 
            ),
          ),

          Expanded(
            child: FlatButton(
              onPressed: () {
                setState(() {
                  nextMusic();
                  print('fast forward!');                                      
                });
              },
              child: Icon(Icons.fast_forward, color: Colors.white)
            ),
          ),
          
        ],
      ),
    );
  }


  @override 
  Widget build(BuildContext context) {
        
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('SIMPLE MUSIC APP', 
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'Pacifico',
            fontWeight: FontWeight.bold, 
            color: Colors.white)
          ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            topBar(),
            midRow(),
            bottomRow()                     
          ],
        ),
      ),
    );
  }
}