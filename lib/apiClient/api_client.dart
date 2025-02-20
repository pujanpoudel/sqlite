import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    baseUrl: 'https://dummyjson.com/',
  ));

  Future<List<User>> getUsers() async {
    Response response = await _dio.get('/users');
    Map<String, dynamic> data = response.data;
    var userList = UserBaseModel.fromJson(data).users;
    return userList;
  }
}
