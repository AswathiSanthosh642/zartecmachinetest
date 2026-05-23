
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {

  late Dio dio;

  DioClient(){
    dio=Dio();

    dio.options.baseUrl="https://faheemkodi.github.io";
    dio.options.connectTimeout=const Duration(seconds: 10);
    dio.options.receiveTimeout=const Duration(seconds: 10);
    dio.options.headers={
      'Accept':'application/json',
      'Content-Type':'application/json'
    };


    dio.interceptors.add(PrettyDioLogger(
        request:true,
        requestBody: true,
        responseBody: true,
        error: true

    ));

  }


}