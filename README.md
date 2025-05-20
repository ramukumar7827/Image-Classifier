# 📷 Flutter Image Classifier App

## 🚀 Overview
This is a **Flutter-based image classification app** that integrates a **TensorFlow Lite model** to classify images using the **CIFAR-10 dataset**. Users can select an image from **Gallery or Camera**, and the app will predict the category using **deep learning**.

---

## 🛠 Features
- ✅ **TensorFlow Lite Integration** for real-time image classification
- ✅ **CNN-Based Model** trained on CIFAR-10 for accurate predictions
- ✅ **Smooth UI with Image Preview & Buttons**
- ✅ **Progress Bar Indicator** while processing images
- ✅ **Optimized for Mobile Deployment**

---

## 📌 Dependencies
Install required packages before running:
```bash
flutter pub add tflite_flutter image_picker image

📦 flutter-image-classifier
 ┣ assets
 ┃ ┣ 📜 image_classifier.tflite  # TensorFlow Lite Model
 ┣ 📂 lib
 ┃ ┣ 📜 main.dart                # Main Flutter Code
 ┣ 📜 pubspec.yaml               # Flutter dependencies & assets
 ┣ 📜 README.md                   # Project Documentation

flutter pub get
flutter run


