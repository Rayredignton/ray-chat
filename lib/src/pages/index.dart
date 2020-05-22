import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';


class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 return Material(
  child: Scaffold(
            appBar: AppBar(
                  backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Ray's", style: TextStyle(color: Colors.black) ,),
        Text("chat", style: TextStyle(color: Colors.pink)),
        ],
        ),
        elevation: 2.0,
        centerTitle: true,
      ),
              
            

    body: Column(
       
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Center(
            
            child: Container(
              height:300,
              width: 300,

              child: CircleAvatar(
                child: ClipOval(
                  child: new FlareActor("assets/teddy_test.flr",
                   alignment: Alignment.center, fit: BoxFit.contain, 
                    animation: "success",),
                ),
                backgroundColor: Colors.white,
              )

            ),
          ),


          //just for vertical spacing
          SizedBox(
            height: 20,width: 10,
          ),


          //container for textfields user name and password
          Container(
            height: 50,
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white
            ),

            child: Column(
              children: <Widget>[

                 Expanded(
                        child: TextField(
                      controller: _channelController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.search,),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid,),
                          ),
                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid
                            )
                        ),
                        errorText:
                            _validateError ? 'Channel name is mandatory' : null,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        hintText: 'Channel name',
                      ),
                    ))

              ],
            ),
          ),

          //container for raised button
          Container(
            width: 350,
            height: 70,
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: onJoin,
                color: Colors.pink,
                child: Text("Join", style: TextStyle(color: Colors.white),),

                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30),
                )
        

        
            ),
          )
        ],
                ),
  ),
 );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
