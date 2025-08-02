import 'dart:convert';
import 'nigerian_states_repository.dart';

class NigeriaData {
  List<NigerianStates> states;

  NigeriaData({required this.states});

  factory NigeriaData.fromJson(String json) {
    final jsonData = jsonDecode(json);
    final states = (jsonData as List<dynamic>)
        .map((state) => NigerianStates.fromJson(state))
        .toList()
        .cast<NigerianStates>();

    return NigeriaData(states: states);
  }
}
