import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField()
  static const DEV = _Env.DEV;

  @EnviedField()
  static const SEP = _Env.SEP;

  @EnviedField()
  static const NOTIFKEY = _Env.NOTIFKEY;

  @EnviedField()
  static const EXCHANGEKEY = _Env.EXCHANGEKEY;

  @EnviedField()
  static const SOL = _Env.SOL;
}
