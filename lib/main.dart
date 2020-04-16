import 'package:flutter/material.dart';
import './settingholder.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';


SettingsHolder settings = SettingsHolder();



class MyAppStart extends StatefulWidget {

 @override
 State<StatefulWidget> createState() => MyAppStartState();

}

class MyAppStartState extends State {

 

 @override
 void initState() {
   settings.getSettings();
   super.initState();

 }

 @override
 Widget build(BuildContext context) {

return Scaffold(
      appBar: AppBar(title: Text('ALEXATRAINS')),
      body: Column(children: <Widget>[
        SizedBox(height: 20.0),
        Image(image: AssetImage('images/gracmain.png'),),
        SizedBox(height: 20.0),
        Center(child: RaisedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      },
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
       child: Text('Личный кабинет'))),
       SizedBox(height: 20.0),
        Center(child: RaisedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      },
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
       child: Text('Личный кабинет'))),
       SizedBox(height: 20.0),
        Center(child: RaisedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      },
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
       child: Text('Личный кабинет')))],)
);

 }
}


class MyApp extends StatefulWidget {

 @override
 State<StatefulWidget> createState() => MyAppState();

}

class MyAppState extends State {


 @override
 void initState() {
   //здесь еще ченить активируем
   super.initState();

 }

 @override
 Widget build(BuildContext context) {
   
   int books =settings.getID();
   print("ID getted on start:"+books.toString());

if (books>0) {
  
return Scaffold(
      appBar: AppBar(title: Text('Личный кабинет')),
      body: Column(children: <Widget>[
        SizedBox(height: 20.0),
        RaisedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyVideo()));
      }, child: Text('Мои тренировки')),

        RaisedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      }, child: Text('Удалить регистрацию')),
        RaisedButton(onPressed: (){
          settings.clearSettings();
        Navigator.pop(context);
      }, child: Text('Назад'))
      ]),
    );

} else 

return Scaffold(
      appBar: AppBar(title: Text('Личный кабинет')),
      body: Center(child: 
Column(children: <Widget>[
SizedBox(height: 20.0),
Text("РЕГИСТРАЦИЯ"),
MyRegisterForm(),

],)
),);
 }

}

class MyRegisterForm extends StatefulWidget {

  @override

  State<StatefulWidget> createState() => MyFormState();

}


class MyFormState extends State {

  final _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) {

    return Container(padding: EdgeInsets.all(10.0), child:  Form(key: _formKey, child: Column(children: <Widget>[
       Text('Ваше имя:', style: TextStyle(fontSize: 20.0),),
       TextFormField(validator: (value){
        if (value.isEmpty) return 'Пожалуйста введите свое имя';
        settings.setName(0, value);
        
      }),

       SizedBox(height: 20.0),

       Text('Ваша фамилия:', style: TextStyle(fontSize: 20.0),),
       TextFormField(validator: (value){
        if (value.isEmpty) return 'Пожалуйста введите свою фамилию';
        settings.setName(1, value);
      }),

       SizedBox(height: 20.0),

       Text('Ваш телефон:', style: TextStyle(fontSize: 20.0),),
       TextFormField(validator: (value){
        if (value.isEmpty) return 'Пожалуйста введите номер вашего телефона';
        settings.setPhone(value);
      }),

       SizedBox(height: 20.0),

       Text('Пароль (Запомните его!):', style: TextStyle(fontSize: 20.0),),
       TextFormField(validator: (value){
        if (value.isEmpty) return 'Введите произвольное значение, как пароль';
        settings.setPass(value);
      }),

       SizedBox(height: 20.0),

       RaisedButton(onPressed: (){
        if(_formKey.currentState.validate()) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Данные успешно отправлены'), backgroundColor: Colors.green,));
        settings.setSettings();
       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        }
      }, child: Text('Зарегистрировать'), color: Colors.blue, textColor: Colors.white,),

    ],)));

  }

}

class TheMessages extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои сообщения')),
      body: Center(child: RaisedButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text('Назад'))),
    );
  }
}

class TheVideos extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои уроки')),
      body: Center(child: RaisedButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text('Назад'))),
    );
  }
}




Future<List<VideoTile>> fetchTile(http.Client client) async {
  final response = await client.post('https://alexakosheleva.ru/appapi/index.php', body: {'themode':'getvideos'});
 return compute(parseTiles, response.body);
}

List<VideoTile> parseTiles(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<VideoTile>((json) => VideoTile.fromJson(json)).toList();
}

class VideoTile {
  
  final String id;
  final String title;
  final String videourl;

  VideoTile({ this.id, this.title, this.videourl});

  factory VideoTile.fromJson(Map<String, dynamic> json) {
    return VideoTile(
      
      id: json['trenID'],
      title: json['title'],
      videourl: json['thelink'],
    );
  }
}

class MyVideo extends StatefulWidget {
  MyVideo({Key key}) : super(key: key);

  @override
  _MyVideoState createState() => _MyVideoState();
}

class _MyVideoState extends State<MyVideo> {
  Future<VideoTile> videoTile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Мои тренировки'),
        ),
        body: FutureBuilder<List<VideoTile>>(
        future: fetchTile(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? TilesList(tiles: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TilesList extends StatelessWidget {
  final List<VideoTile> tiles;

  TilesList({Key key, this.tiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
        GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        settings.setVideoToPlay(tiles[index].videourl);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerApp()));
      },
      child:  ListTile(leading: Icon(Icons.account_circle),
        title: Text(tiles[index].title))) ,
        Divider()
        ],);
        
      },
    );
  }
}


class VideoPlayerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  String v2play;
  @override
  void initState() {
    v2play = 'https://alexakosheleva.ru/appapi/videos/' + settings.getVideoToPlay();
    print(v2play);
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(v2play,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Видео тренировка'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void main() => runApp( MaterialApp(
  home: MyAppStart()));