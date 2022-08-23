import 'package:app_learn_english/Providers/TargetProvider.dart';
import 'package:app_learn_english/logError/LogCustom.dart';

class FunctionService {
  static final FunctionService _singleton = FunctionService._internal();
  factory FunctionService() {
    return _singleton;
  }
  FunctionService._internal();
  Function? initProviderFunction;
  TargetProvider? targetProvider;

  bool isImpl = false;
  setInitProviderFunction(Function func) {
    printYellow("SETTING FUNC");
    this.initProviderFunction = func;
  }

  setProvider(TargetProvider targetProvider) {
    this.targetProvider = targetProvider;
  }

  getProvider() {
    return this.targetProvider;
  }

  implProviderFunction() {
    if (this.isImpl == false) {
      printBlue("RETURN FUNC");
      this.isImpl = true;
      this.initProviderFunction!();
    } else {
      printRed("Không chạy lần nữa nhé :)))");
    }
  }
}
