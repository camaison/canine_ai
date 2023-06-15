import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:canine_ai/prediction_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canine AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  Interpreter? _interpreter;
  bool _isLoading = true;
  late List heap;

  @override
  void initState() {
    super.initState();
    loadModel().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> loadModel() async {
    try {
      String modelPath = 'assets/canine_ai_model.tflite';
      // Load model
      final ByteData modelData = await rootBundle.load(modelPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List();
      // Initialize interpreter
      _interpreter = await Interpreter.fromBuffer(modelBytes);
    } catch (e) {
      print('Failed to load the model or labels: $e');
    }
  }

  Future<void> runInference(img.Image image) async {
    // Preprocess the image
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
    var input = Float32List(1 * 224 * 224 * 3); // Reshape input tensor

    var index = 0;
    for (var i = 0; i < 224; i++) {
      for (var j = 0; j < 224; j++) {
        var pixel = resizedImage.getPixel(j, i);
        input[index++] =
            (img.getRed(pixel) - 128) / 255.0; // Normalize red channel
        input[index++] =
            (img.getGreen(pixel) - 128) / 255.0; // Normalize green channel
        input[index++] =
            (img.getBlue(pixel) - 128) / 255.0; // Normalize blue channel
      }
    }

    // Allocate output tensor
    var output = Float32List(1 * 120);

    // Prepare input tensor
    var inputBuffer = input.reshape([1, 224, 224, 3]);

    // Prepare output tensor
    var outputBuffer = output.reshape([1, 120]);

    // Run inference
    _interpreter!.run(inputBuffer, outputBuffer);

    List<Map<String, dynamic>> pairs = [];
    for (int i = 0; i < outputBuffer[0].length; i++) {
      pairs.add({'score': outputBuffer[0][i], 'index': i});
    }

    pairs.sort((a, b) => -a['score'].compareTo(b['score']));

    heap = [pairs[0], pairs[1], pairs[2]];
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
        _image = File(pickedImage.path);
      });
      final bytes = await pickedImage.readAsBytes();
      final image = img.decodeImage(bytes);

      await runInference(image!);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double containerWidth = screenSize.width * 0.9;
    final double containerHeight = screenSize.height * 0.45;
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF416275), //.withOpacity(0.2),
              // Color(0xFFbbcdda), //.withOpacity(0.2),
              Color(0xFFf6e0b7),
            ],
          ),
        ),
      ),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SafeArea(
              top: false,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Container(
                      height: 80,
                      width: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )),
                Expanded(
                    child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _image != null
                                    ? [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                                height: containerHeight,
                                                width: containerWidth,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          width: containerWidth,
                                                          height:
                                                              containerHeight,
                                                          child: Image.file(
                                                            _image!,
                                                            fit: BoxFit.fill,
                                                          ))
                                                    ]))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              imageSource(
                                                  name: "Camera", type: 0),
                                              imageSource(
                                                  name: "Gallery", type: 1),
                                              predict(),
                                            ])
                                      ]
                                    : [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                                height: containerHeight,
                                                width: containerWidth,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image(
                                                          width: containerWidth,
                                                          height:
                                                              containerHeight,
                                                          image: const AssetImage(
                                                              "assets/images/placeholder.png")),
                                                    ]))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              imageSource(
                                                  name: "Camera", type: 0),
                                              imageSource(
                                                  name: "Gallery", type: 1)
                                            ])
                                      ])))
              ])))
    ]));
  }

  Widget imageSource({String name = '', int type = 0}) {
    return GestureDetector(
      onTap: () {
        type == 0
            ? _pickImage(ImageSource.camera)
            : _pickImage(ImageSource.gallery);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
          ),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            // border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 20, bottom: 20),
              child: Center(
                child: Icon(
                  type == 0 ? Icons.camera : Icons.image,
                  color: Colors.white,
                  size: 50,
                ),
              )),
        ),
      ),
    );
  }

  Widget predict() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PredictionPage(heap)));
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
          ),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            // border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Padding(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
              child: Center(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 50,
                ),
              )),
        ),
      ),
    );
  }
}
