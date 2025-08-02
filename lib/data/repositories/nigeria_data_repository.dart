import 'package:flutter/services.dart';
import 'nigeria_data_repository2.dart';

class NigeriaDataRepository {
  Future<NigeriaData> loadNigeriaData() async {
    final jsonString = await rootBundle.loadString('assets/nigeria_data.json');
    return NigeriaData.fromJson(jsonString);
  }
}
