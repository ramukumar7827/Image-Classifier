import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Classifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ImageClassifierScreen(),
    );
  }
}

class ImageClassifierScreen extends StatefulWidget {
  const ImageClassifierScreen({super.key});

  @override
  _ImageClassifierScreenState createState() => _ImageClassifierScreenState();
}

class _ImageClassifierScreenState extends State<ImageClassifierScreen> {
  File? _image;
  late Interpreter _interpreter;
  String _prediction = "No Prediction";
  bool _isProcessing = false;

  final List<String> labels = [
    "Airplane",
    "Automobile",
    "Bird",
    "Cat",
    "Deer",
    "Dog",
    "Frog",
    "Horse",
    "Ship",
    "Truck"
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/image_classifier.tflite');
      print("Model Loaded Successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: source);

    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
        _isProcessing = true;
      });
      preprocessImageAndRunModel();
    } else {
      print("No image selected");
    }
  }

  Future<void> preprocessImageAndRunModel() async {
    if (_image == null) {
      print("No image found");
      return;
    }

    try {
      Uint8List inputImage = await _image!.readAsBytes();
      List<List<List<double>>> processedImage = preprocessImage(inputImage);

      var input = [processedImage];
      var output = List.generate(1, (_) => List.filled(10, 0.0));

      _interpreter.run(input, output);

      int predictedIndex =
          output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

      setState(() {
        _prediction = "Prediction: ${labels[predictedIndex]}";
        _isProcessing = false;
      });
    } catch (e) {
      print("Error during prediction: $e");
      setState(() {
        _isProcessing = false;
      });
    }
  }

  List<List<List<double>>> preprocessImage(Uint8List imageData) {
    img.Image image = img.decodeImage(imageData)!;
    img.Image resizedImage = img.copyResize(image, width: 32, height: 32);

    List<List<List<double>>> normalizedImage = [];

    for (int y = 0; y < 32; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < 32; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        row.add([
          pixel.r / 255.0,
          pixel.g / 255.0,
          pixel.b / 255.0,
        ]);
      }
      normalizedImage.add(row);
    }

    return normalizedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Classifier"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: const Icon(Icons.image, size: 100),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_image!,
                        width: 150, height: 150, fit: BoxFit.cover),
                  ),
            const SizedBox(height: 20),
            _isProcessing
                ? const CircularProgressIndicator()
                : Text(
                    _prediction,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







