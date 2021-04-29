import 'package:business_book/dao/menu_dao.dart';
import 'package:business_book/manage_db/menu.dart';
import 'package:business_book/screens/page_header.dart';
import 'package:business_book/utility/singleInstance/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sembast/timestamp.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math';

class AddFolder extends StatefulWidget {
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  final _form = GlobalKey<FormState>();
  final _folderName = TextEditingController();
  final _folderDescription = TextEditingController();
  final MenuAction action = MenuAction();
  final SpeechToText speech = SpeechToText();
  bool _hasSpeech = false;
  bool _isListinig = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];

  bool isUpdate = false;
  bool isReady = false;
  Menu currentItem = Menu(
      catagoryName: "",
      catagoryDescription: '',
      createdOn: Timestamp.now(),
      parentName: null,
      uId: 0);

  Future _createOrUpdateFolder() async {
    if (this.isUpdate)
      _updateFolder();
    else
      _createFolder();
  }

  Future _updateFolder() async {
    _form.currentState.save();
    var state = _form.currentState.validate();
    if (state) {
      FocusScope.of(context).unfocus();
      this.currentItem.catagoryName = _folderName.text.trim();
      this.currentItem.catagoryDescription = _folderDescription.text.trim();
      this.currentItem.createdOn = Timestamp.now();
      await action.updateMenu(this.currentItem).then((result) {
        if (result > 0) {
          Fluttertoast.showToast(msg: "Folder updated successfully");
        } else {
          Fluttertoast.showToast(msg: "Fail to update.");
        }
      });
    }
  }

  Future _createFolder() async {
    _form.currentState.save();
    var state = _form.currentState.validate();
    if (state) {
      FocusScope.of(context).unfocus();
      await action
          .insert(Menu(
              parentName: null,
              catagoryDescription: _folderDescription.text.trim(),
              createdOn: Timestamp.now(),
              catagoryName: _folderName.text.trim()))
          .then((result) {
        if (result != null && result > 0) {
          _folderName.text = '';
          _folderDescription.text = '';
          Fluttertoast.showToast(msg: "Folder created successfully");
        } else {
          Fluttertoast.showToast(msg: "Folder already exists.");
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    this.initSpeechState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final catagoryName = ModalRoute.of(context).settings.arguments as String;
      if (catagoryName != null && catagoryName.isNotEmpty) {
        this.getCurrentRecord(catagoryName);
      } else {
        _folderDescription.text = "";
        _folderName.text = "";
        setState(() {
          isUpdate = false;
          isReady = true;
          currentItem = Menu(
              catagoryName: "",
              catagoryDescription: '',
              createdOn: Timestamp.now(),
              parentName: null,
              uId: 0);
        });
      }
    });
    super.initState();
  }

  Future<Menu> getCurrentRecord(String catagoryName) async {
    await this.action.find(catagoryName).then((result) {
      if (result != null) {
        _folderDescription.text = result.catagoryDescription;
        _folderName.text = result.catagoryName;
        setState(() {
          currentItem = result;
          isReady = true;
          isUpdate = true;
        });
      } else {
        Fluttertoast.showToast(msg: "Unable to find. Contact admin.");
      }
    });
  }

  Future<void> initSpeechState() async {
    var hasSpeech =
        await speech.initialize(onError: errorListener, onStatus: statusListener
            //debugLogging: true,
            //finalTimeout: Duration(milliseconds: 0)
            );
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    print("Speach init status: $hasSpeech");

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
      _isListinig = true;
    });
  }

  void _manageSpeachListining() {
    if (!_isListinig) {
      this.initSpeechState().then((hasSpeech) {
        if (_hasSpeech && !speech.isListening) {
          this.startListening();
        } else {
          Fluttertoast.showToast(msg: "Speach recogonizer not initialized.");
        }
      });
    } else {
      this.stopListening();
    }
  }

  void startListening() {
    print("Start listining.");
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(minutes: 5),
        //pauseFor: Duration(seconds: 2),
        //partialResults: false,
        localeId: _currentLocaleId,
        //onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    print("Stop listining.");
    speech.stop();
    setState(() {
      level = 0.0;
      _isListinig = false;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    print('Result listener ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });

    print('${result.recognizedWords} - ${result.finalResult}');
    this._folderDescription.text = result.recognizedWords;
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    print(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _folderName.dispose();
    _folderDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(
        pageTitle: "Add Folder",
      ),
      body: Container(
        padding: EdgeInsets.all(Configuration.pageWidget * .08),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Use below form to add new folder.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      alignment: Alignment.center,
                      child: Text(
                        'After adding folder you can add text, pdf, doc and images.',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Please follow.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 4,
                                  right: 10,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.dotCircle,
                                  size: 12,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                'Can use any alpha numeric charater\'s with spaces.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 4,
                                  right: 10,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.dotCircle,
                                  size: 12,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                'Only  \'_\'  (underscore) can be used as a special charater.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 4,
                                  right: 10,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.dotCircle,
                                  size: 12,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                'For description use max of 500 any character\'s.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: Configuration.pageWidget * .04,
                  top: Configuration.pageWidget * .04,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    border: OutlineInputBorder(),
                    labelText: 'Folder Name',
                    hintText: 'Enter folder name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim() == "")
                      return "Folder name is mandatory";
                    return null;
                  },
                  controller: _folderName,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: TextFormField(
                    //controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Folder description',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Description',
                    ),
                    maxLines: 6,
                    controller: _folderDescription,
                    validator: (value) {
                      if (value == null || value.trim() == "")
                        return "Folder description is mandatory";
                      return null;
                    }),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Configuration.pageWidget * .04),
                child: RaisedButton(
                  onPressed: () {
                    _createOrUpdateFolder();
                  },
                  child: !isReady
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : isUpdate
                          ? Text("Update")
                          : Text("Add"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: FloatingActionButton(
          onPressed: () {
            _manageSpeachListining();
          },
          child: Icon(FontAwesomeIcons.microphone),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
