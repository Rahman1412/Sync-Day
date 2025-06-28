import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService{
  final GetStorage _storage = GetStorage();

  Future<void> setValue(String key,dynamic value) async{
    await _storage.write(key, value);
  }

  Future<dynamic> getValue(String key) async{
    return await _storage.read(key);
  }

  Future<void> removeValue(String key) async{
    await _storage.remove(key);
  }

  Future<void> clearAll() async{
    await _storage.erase();
  }
}