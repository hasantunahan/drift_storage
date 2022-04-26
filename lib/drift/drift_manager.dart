class DriftManager {
  DriftManager._init();

  static DriftManager? _instance;

  static DriftManager get instance {
    _instance ??= DriftManager._init();
    return _instance!;
  }


}
