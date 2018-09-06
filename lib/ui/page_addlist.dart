import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewTaskPage extends StatefulWidget {
  final FirebaseUser user;

  NewTaskPage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TextEditingController listNameController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color pickerColor = Color(0xff6633ff);
  Color currentColor = Color(0xff6633ff);

  ValueChanged<Color> onColorChanged;

  void addToFirebase() async {
    bool isExist = false;

    QuerySnapshot query =
        await Firestore.instance.collection(widget.user.uid).getDocuments();

    query.documents.forEach((doc) {
      if (listNameController.text.toString() == doc.documentID) {
        isExist = true;
      }
    });

    if (isExist == false && listNameController.text.isNotEmpty) {
      await Firestore.instance
          .collection(widget.user.uid)
          .document(listNameController.text.toString().trim())
          .setData({
        "color": currentColor.value.toString(),
        "date": DateTime.now().millisecondsSinceEpoch
      });

      listNameController.clear();

      pickerColor = Color(0xff6633ff);
      currentColor = Color(0xff6633ff);

      Navigator.of(context).pop();
    }
    if (isExist == true) {
      showInSnackBar("This list already exists");
    }
    if (listNameController.text.isEmpty) {
      showInSnackBar("Please enter a name");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: new Stack(
          children: <Widget>[
            _getToolbar(context),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'New',
                                  style: new TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'List',
                                  style: new TextStyle(
                                      fontSize: 28.0, color: Colors.grey),
                                )
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              labelText: "List name",
                              contentPadding: EdgeInsets.only(
                                  left: 16.0,
                                  top: 20.0,
                                  right: 16.0,
                                  bottom: 5.0)),
                          controller: listNameController,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 20,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                        ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          child: RaisedButton(
                            elevation: 3.0,
                            onPressed: () {
                              pickerColor = currentColor;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: changeColor,
                                        enableLabel: true,
                                        colorPickerWidth: 1000.0,
                                        pickerAreaHeightPercent: 0.7,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Got it'),
                                        onPressed: () {
                                          setState(
                                              () => currentColor = pickerColor);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Card color'),
                            color: currentColor,
                            textColor: const Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: new Column(
                      children: <Widget>[
                        new RaisedButton(
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          elevation: 4.0,
                          splashColor: Colors.deepPurple,
                          onPressed: addToFirebase,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();

    _scaffoldKey.currentState?.showSnackBar(new SnackBar(
      content: new Text(value, textAlign: TextAlign.center),
      backgroundColor: currentColor,
      duration: Duration(seconds: 3),
    ));
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 10.0, top: 40.0),
      child: new BackButton(color: Colors.black),
    );
  }
}
