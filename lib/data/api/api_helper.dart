import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:swipe/swipe.dart';
import 'api_exception.dart';
import 'package:flutter/material.dart';

class APIHelper {
  late Dio _dio;
  static const timeOut = 15;

  APIHelper() {
    _dio = Dio();
  }

  setupHeader({String? accessToken}) {
    if (accessToken == null || accessToken.isEmpty) {}

    if (Swipe.testMode) {
      _dio.interceptors.add(LogInterceptor(
          requestBody: true, responseBody: true, requestHeader: true));
    }

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(onRequest: (options, handler) {
        if (accessToken == null) {
          throw UnauthorisedException(
              'You must set your API key with Swipe.API_KEY.');
        }

        options.headers["Accept"] = "application/json";
        options.headers["Content-Type"] = "application/json";
        options.headers["Authorization"] = "Bearer " + accessToken;
        return handler.next(options);
      }),
    );

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  Future<T?> getRequest<T>({
    @required hostUrl,
    @required String? path,
    Map<String, String>? queryParameters,
    String? accessToken,
    Map<String, String>? data,
  }) async {
    try {
      setupHeader(accessToken: accessToken);

      final response = await _dio
          .get(hostUrl + path, queryParameters: queryParameters)
          .timeout(
        const Duration(seconds: timeOut),
        onTimeout: () {
          throw FetchDataException('the connection has timed out');
        },
      );
      return _returnResponse<T>(response, null);
    } on SocketException {
      throw FetchDataException(
          'Unable to reach server, please check your connection.', 0);
    } on DioError catch (e) {
      return _returnResponse<T>(e.response, e.message);
    }
  }

  Future<T?> postRequest<T>({
    @required hostUrl,
    @required String? path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? data,
    String? accessToken,
  }) async {
    try {
      setupHeader(accessToken: accessToken);

      final response = await _dio
          .post(hostUrl + path, queryParameters: queryParameters, data: data)
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw FetchDataException('the connection has timed out');
        },
      );
      return _returnResponse<T>(response, null);
    } on SocketException {
      throw FetchDataException(
          'Unable to reach server, please check your connection.', 0);
    } on DioError catch (e) {
      return _returnResponse<T>(e.response, e.message);
    }
  }

  Future<T?> putRequest<T>({
    @required hostUrl,
    @required String? path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? data,
    String? accessToken,
  }) async {
    try {
      setupHeader(accessToken: accessToken);

      final response = await _dio
          .put(hostUrl + path, queryParameters: queryParameters, data: data)
          .timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          throw FetchDataException('the connection has timed out');
        },
      );
      return _returnResponse<T>(response, null);
    } on SocketException {
      throw FetchDataException(
          'Unable to reach server, please check your connection.', 0);
    } on DioError catch (e) {
      return _returnResponse<T>(e.response, e.message);
    }
  }

  Future<T?> deleteRequest<T>({
    @required hostUrl,
    @required String? path,
    Map<String, String>? queryParameters,
    String? accessToken,
    Map<String, String>? data,
  }) async {
    try {
      setupHeader(accessToken: accessToken);

      final response = await _dio
          .delete(hostUrl + path, queryParameters: queryParameters)
          .timeout(
        const Duration(seconds: timeOut),
        onTimeout: () {
          throw FetchDataException('the connection has timed out');
        },
      );
      return _returnResponse<T>(response, null);
    } on SocketException {
      throw FetchDataException(
          'Unable to reach server, please check your connection.', 0);
    } on DioError catch (e) {
      return _returnResponse<T>(e.response, e.message);
    }
  }

  T? _returnResponse<T>(Response? response, String? errorMessage) {
    if (response == null || response.statusCode == null) {
      throw FetchDataException(errorMessage ?? 'An Exception occurs.');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
      case 422:
        throw BadRequestException(
            json.encode(response.data), response.statusCode);
      case 401:
      case 403:
        throw UnauthorisedException(
            json.encode(response.data), response.statusCode);
      case 404:
        return null;
      case 500:
      default:
        throw FetchDataException(
            json.encode(response.data), response.statusCode);
    }
  }
}
