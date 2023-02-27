import 'dart:convert';

import 'package:get/get.dart';




import '../../../data/headline_response.dart';
import '../../../utils/api.dart';class DashboardController extends GetxController {
  final _getConnect = GetConnect();
  //TODO: Implement DashboardController

  Future<headlineResponse> getHeadline() async {
	//memanggil fungsi getConnect untuk melakukan request ke BaseUrl.headline
  final response = await _getConnect.get(BaseUrl.headline);
	//mengembalikan data response dalam bentuk headlineResponse setelah di-decode dari JSON
  return headlineResponse.fromJson(jsonDecode(response.body));
}
  

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
