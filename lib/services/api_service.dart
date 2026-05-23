
import 'package:dio/dio.dart';

import '../models/RespCategories.dart';
import 'dio_client.dart';

class ApiService {

  late Dio _dio;

  ApiService(){
    _dio=DioClient().dio;
  }

  Future<List<Categories>?> fetchCategory() async {
    var response = await _dio.get("/mock-menu-api/menu.json");

    try {
      if (response.statusCode == 200||response.statusCode==201) {
        var resp=RespCategories.fromJson(response.data);
        return resp.categories;
      }
    }
    on DioException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e);
    }
    return null;
  }

}