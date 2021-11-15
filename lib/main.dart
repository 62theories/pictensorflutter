import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

void main() {
  runApp(ScanModelPage());
}

class ScanModelPage extends StatefulWidget {
  @override
  _ScanModelPageState createState() => _ScanModelPageState();
}

class _ScanModelPageState extends State<ScanModelPage> {
  File? image1;
  File? image2;
  File? image3;

  String image1Base64 = '';
  String image2Base64 = '';
  String image3Base64 = '';

  String imageModel =
      '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';

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var stream =
          new http.ByteStream(DelegatingStream.typed(image.openRead()));

      var length = await image.length();
      var b = await stream.toBytes();
      var request = new http.MultipartRequest(
          "POST", Uri.parse(Uri.encodeFull('http://139.59.119.19/upload')));
      String fileName = 'test${DateTime.now().millisecondsSinceEpoch}.jpg';
      var multipartFile = new http.MultipartFile.fromBytes('file', b);
      // ('file', stream, length, filename: fileName);

      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(fileName);
      print('response');
      print(response.body);
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print('+++++++++++++++++++++++++++++');
      //   print(value);
      //   if (value.length > 100) {
      //     setState(() {
      //       imageModel = value.replaceAll('data:image/png;base64,', '');
      //     });
      //   }

      //   // print(value);
      // });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whenInit();
  }

  whenInit() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.red,
            title: Text(
              'ScanModal',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context)
              //         .push(MaterialPageRoute(builder: (BuildContext context) {
              //       return SearchPage();
              //     })).then((value) => whenInit());
              //   },
              //   child: Icon(
              //     Icons.search,
              //     color: mSecondBackgroundColor,
              //     size: 36,
              //   ),
              // ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade100,
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  // createSubTitle(),
                  Expanded(
                    child: CustomScrollView(
                      // controller: _scrollController,
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [scanModelImage()],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  scanModelImage() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [BoxShadow(color: Colors.blueAccent)]),
                child: IconButton(
                  icon: image1 != null
                      ? Image.file(image1!)
                      : Icon(Icons.camera_alt),
                  iconSize: 50.0,
                  onPressed: () async {
                    await pickImage();
                  },
                ),
              ),
              Text('scan-model'),
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [BoxShadow(color: Colors.blueAccent)]),
                child: IconButton(
                  icon: imageModel != ''
                      ? Image.memory(base64Decode(imageModel))
                      : Icon(Icons.camera_alt),
                  iconSize: 50.0,
                  onPressed: () async {
                    await pickImage();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
