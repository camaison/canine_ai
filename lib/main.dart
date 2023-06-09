// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Upload App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   File? _image;
//   final picker = ImagePicker();
//   late var interpreter;

//   @override
//   void initState() {
//     loadModel();
//     super.initState();
//   }

//   Future loadModel() async {
//     interpreter =
//         await tfl.Interpreter.fromAsset('assets/canine_ai_model.tflite');
//     print("Model Initialized");
//   }

//   Uint8List imageToByteListUint8(img.Image image) {
//     var resizedImage = img.copyResize(image, width: 224, height: 224);
//     var convertedBytes = Uint8List(1 * 224 * 224 * 3);
//     var buffer = Uint8List.view(convertedBytes.buffer);
//     var pixelIndex = 0;
//     for (var y = 0; y < resizedImage.height; y++) {
//       for (var x = 0; x < resizedImage.width; x++) {
//         var pixel = resizedImage.getPixel(x, y);
//         buffer[pixelIndex++] = (img.getRed(pixel) ~/ 255); // R
//         buffer[pixelIndex++] = (img.getGreen(pixel) ~/ 255); // G
//         buffer[pixelIndex++] = (img.getBlue(pixel) ~/ 255); // B
//       }
//     }
//     return convertedBytes;
//   }

//   Future<List<double>> runInference(
//       tfl.Interpreter interpreter, Uint8List input) async {
//     final inputs = [input];
//     final outputs = List<List<double>>.generate(
//         interpreter.getOutputTensors().length,
//         (index) =>
//             List.filled(interpreter.getOutputTensors()[index].shape[1], 0.0));

//     interpreter.run(inputs, outputs);

//     // Process the output tensor
//     final outputData = outputs[0];

//     return outputData;
//   }

//   Future<void> _classifyImage(File imageFile) async {
//     var imageBytes = await imageFile.readAsBytes();
//     var image = img.decodeImage(imageBytes);
//     print("Uploaded!");

//     // Resize the image to the required input shape (224x224)
//     var resizedImage = img.copyResize(image!, width: 224, height: 224);

//     // Convert the image to a byte list
//     var input = imageToByteListUint8(resizedImage);

//     print("input: ${input[0]}");

//     List<double> outputData = await runInference(interpreter, input);
//     print("Output: $outputData");

//     // // Run inference on the model
//     // var output = await Tflite.runModelOnBinary(binary: input);

//     // // Process the output...

//     // // Unload the TFLite model
//     // Tflite.close();
//   }

//   Future getImage(ImageSource source) async {
//     final pickedFile = await picker.getImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         //print(Image.file(_image!));
//         _classifyImage(_image!);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Upload App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null
//                 ? Image.file(_image!)
//                 : const Text('No image selected.'),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => getImage(ImageSource.gallery),
//               child: const Text('Select from Gallery'),
//             ),
//             const SizedBox(height: 8.0),
//             ElevatedButton(
//               onPressed: () => getImage(ImageSource.camera),
//               child: const Text('Take a Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isLoading = true;
  String _prediction = '';
  double _confidence = 0.0;

  Map labels = {
    0: 'boston_bull',
    1: 'dingo',
    2: 'pekinese',
    3: 'bluetick',
    4: 'golden_retriever',
    5: 'bedlington_terrier',
    6: 'borzoi',
    7: 'basenji',
    8: 'scottish_deerhound',
    9: 'shetland_sheepdog',
    10: 'walker_hound',
    11: 'maltese_dog',
    12: 'norfolk_terrier',
    13: 'african_hunting_dog',
    14: 'wire-haired_fox_terrier',
    15: 'redbone',
    16: 'lakeland_terrier',
    17: 'boxer',
    18: 'doberman',
    19: 'otterhound',
    20: 'standard_schnauzer',
    21: 'irish_water_spaniel',
    22: 'black-and-tan_coonhound',
    23: 'cairn',
    24: 'affenpinscher',
    25: 'labrador_retriever',
    26: 'ibizan_hound',
    27: 'english_setter',
    28: 'weimaraner',
    29: 'giant_schnauzer',
    30: 'groenendael',
    31: 'dhole',
    32: 'toy_poodle',
    33: 'border_terrier',
    34: 'tibetan_terrier',
    35: 'norwegian_elkhound',
    36: 'shih-tzu',
    37: 'irish_terrier',
    38: 'kuvasz',
    39: 'german_shepherd',
    40: 'greater_swiss_mountain_dog',
    41: 'basset',
    42: 'australian_terrier',
    43: 'schipperke',
    44: 'rhodesian_ridgeback',
    45: 'irish_setter',
    46: 'appenzeller',
    47: 'bloodhound',
    48: 'samoyed',
    49: 'miniature_schnauzer',
    50: 'brittany_spaniel',
    51: 'kelpie',
    52: 'papillon',
    53: 'border_collie',
    54: 'entlebucher',
    55: 'collie',
    56: 'malamute',
    57: 'welsh_springer_spaniel',
    58: 'chihuahua',
    59: 'saluki',
    60: 'pug',
    61: 'malinois',
    62: 'komondor',
    63: 'airedale',
    64: 'leonberg',
    65: 'mexican_hairless',
    66: 'bull_mastiff',
    67: 'bernese_mountain_dog',
    68: 'american_staffordshire_terrier',
    69: 'lhasa',
    70: 'cardigan',
    71: 'italian_greyhound',
    72: 'clumber',
    73: 'scotch_terrier',
    74: 'afghan_hound',
    75: 'old_english_sheepdog',
    76: 'saint_bernard',
    77: 'miniature_pinscher',
    78: 'eskimo_dog',
    79: 'irish_wolfhound',
    80: 'brabancon_griffon',
    81: 'toy_terrier',
    82: 'chow',
    83: 'flat-coated_retriever',
    84: 'norwich_terrier',
    85: 'soft-coated_wheaten_terrier',
    86: 'staffordshire_bullterrier',
    87: 'english_foxhound',
    88: 'gordon_setter',
    89: 'siberian_husky',
    90: 'newfoundland',
    91: 'briard',
    92: 'chesapeake_bay_retriever',
    93: 'dandie_dinmont',
    94: 'great_pyrenees',
    95: 'beagle',
    96: 'vizsla',
    97: 'west_highland_white_terrier',
    98: 'kerry_blue_terrier',
    99: 'whippet',
    100: 'sealyham_terrier',
    101: 'standard_poodle',
    102: 'keeshond',
    103: 'japanese_spaniel',
    104: 'miniature_poodle',
    105: 'pomeranian',
    106: 'curly-coated_retriever',
    107: 'yorkshire_terrier',
    108: 'pembroke',
    109: 'great_dane',
    110: 'blenheim_spaniel',
    111: 'silky_terrier',
    112: 'sussex_spaniel',
    113: 'german_short-haired_pointer',
    114: 'french_bulldog',
    115: 'bouvier_des_flandres',
    116: 'tibetan_mastiff',
    117: 'english_springer',
    118: 'cocker_spaniel',
    119: 'rottweiler'
  };

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
      String labelsPath = 'assets/labels.txt';

      // Load model
      final ByteData modelData = await rootBundle.load(modelPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List();

      // Load labels
      final String labelsData = await rootBundle.loadString(labelsPath);
      _labels = labelsData.split('\n');

      // Initialize interpreter
      _interpreter = await Interpreter.fromBuffer(modelBytes);
    } catch (e) {
      print('Failed to load the model or labels: $e');
    }
  }

  Future<void> runInference(img.Image image) async {
    if (_interpreter == null || _labels == null) return;

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

    int maxIndex = 0;
    double maxValue = double.negativeInfinity;

    for (int i = 0; i < outputBuffer[0].length; i++) {
      if (outputBuffer[0][i] > maxValue) {
        maxValue = outputBuffer[0][i];
        maxIndex = i;
      }
    }

    print("Index with the largest entry: $maxIndex");
    print("Largest entry: $maxValue");

    var prediction = labels[maxIndex];
    var confidence = maxValue;

    setState(() {
      _prediction = prediction;
      _confidence = confidence * 100;
    });
  }

/*
  Future<void> runInference(img.Image image) async {
    if (_interpreter == null || _labels == null) return;

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
    //print("Input: $input");

// Allocate output tensor
    var output = Float32List(1 * 120);

// Prepare input tensor
    var inputBuffer = input.reshape([1, 224, 224, 3]);

// Prepare output tensor
    var outputBuffer = output.reshape([1, 120]);

// Run inference
    _interpreter!.run(inputBuffer, outputBuffer);
    // print(outputBuffer[0]);

    /// Find the top prediction
    var maxScore = outputBuffer.cast<double>().reduce((a, b) => a > b ? a : b);
    var maxIndex = outputBuffer.cast<double>().indexOf(maxScore);
//var prediction = _labels![maxIndex];

    print(maxIndex);
    // setState(() {
    //   _prediction = prediction;
    // });
  }*/

  Future<img.Image?> loadImage(String imagePath) async {
    final ByteData imageBytes = await rootBundle.load(imagePath);
    Uint8List bytes = Uint8List.view(imageBytes.buffer);
    return img.decodeImage(bytes);
  }

  Future<void> _classifyImage() async {
    var image = await loadImage('assets/dog.jpg');
    if (image != null) {
      await runInference(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canine AI'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        _classifyImage();
                      },
                      child: Image.asset('assets/dog.jpg', height: 300)),
                  const SizedBox(height: 20),
                  Text(
                    'Prediction: $_prediction',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    //make tet color green

                    'Confidence: ${_confidence.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Canine AI',
    home: HomePage(),
  ));
}
