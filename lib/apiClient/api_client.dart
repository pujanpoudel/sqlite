import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/users/data/model/user_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// final userProvider = FutureProvider<List<User>>((ref) async {
//   final apiClient = ref.watch(apiClientProvider);
//   return await apiClient.getUsers();
// });

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    baseUrl: 'https://dummyjson.com/',
  ));

  Future<List<User>> getUsers() async {
    Response response = await _dio.get('/users');
    Map<String, dynamic> data = response.data;
    return UserBaseModel.fromJson(data).users;
  }
}
