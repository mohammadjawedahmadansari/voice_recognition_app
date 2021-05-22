import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceRecoginitionApp(),
    );
  }
}


class VoiceRecoginitionApp extends StatefulWidget {
  @override
  _VoiceRecoginitionAppState createState() => _VoiceRecoginitionAppState();
}

class _VoiceRecoginitionAppState extends State<VoiceRecoginitionApp> {
  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListener = false;
  String resultText = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() =>_isAvailable = result)
    );
    _speechRecognition.setRecognitionStartedHandler(
        () => setState(()=> _isListener = true),
    );
    _speechRecognition.setRecognitionResultHandler(
        (String speech) => setState(() => resultText = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(
        () => setState(() => _isListener = false),
    );

    _speechRecognition.activate().then((result) => setState(() => _isAvailable = result),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Recognition App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_power_outlined,size: 30,color: Colors.white,),
            onPressed: (){
              exit(0);
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                    backgroundColor: Colors.deepOrange,
                    onPressed: (){
                      if(_isListener)
                        {
                          _speechRecognition.cancel().then((result) => setState(() {
                            _isListener = result;
                              resultText = "";
                          }),
                          );
                        }
                    }
                    ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.pink,
                    onPressed: (){
                    if(_isAvailable && !_isListener)
                   {
                     _speechRecognition.listen(locale: "en_US").then((result) => print('$result'));
                   }
                  }
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                    backgroundColor: Colors.deepPurple,
                    onPressed: (){
                    if(_isListener)
                      {
                        _speechRecognition.stop().then((result) => setState(() => _isListener = result));
                      }
                    }
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(resultText,
              style: TextStyle(fontSize: 24.0),),
            ),
          SizedBox(height: 20,),
          Text('Developed By Jawed Ahmad',
          style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}

