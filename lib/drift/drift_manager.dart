class DriftManager {
  DriftManager._init();

  static DriftManager? _instance;

  static DriftManager get instance {
    _instance ??= DriftManager._init();
    return _instance!;
  }

//https://stackoverflow.com/questions/58324907/how-to-perform-file-encryption-with-flutter-and-dart
}
