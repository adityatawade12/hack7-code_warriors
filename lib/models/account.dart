import 'package:hive/hive.dart';
part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  String accountAddress;
  @HiveField(1)
  String privateKey;
  @HiveField(2)
  String name;
  @HiveField(3)
  String category;

  Account(this.accountAddress, this.privateKey, this.name, this.category);
}
