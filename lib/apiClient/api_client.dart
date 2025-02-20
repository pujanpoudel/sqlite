import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    baseUrl: 'https://dummyjson.com/',
  ));

  Future<List<User>> getUsers() async {
    Response response = await _dio.get('/users');
    Map<String, dynamic> data = response.data;
    var userList = UserBaseModel.fromJson(data).users;
    return userList;
  }
}
