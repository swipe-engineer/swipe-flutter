import 'package:flutter/foundation.dart';
import 'package:swipe/data/repositories/base_repository.dart';

class PaymentLinkRepository extends BaseRepository {
  Future<List<dynamic>?> index({
    int page = 1,
  }) async {
    final jsonApiResult = await apiHelper.getRequest<List<dynamic>>(
      hostUrl: serverUrl,
      path: "api/payment-links&page=$page",
      queryParameters: {},
      accessToken: apiKey,
    );

    return jsonApiResult;
  }

  Future<dynamic?> get({
    @required String? id,
  }) async {
    final jsonApiResult = await apiHelper.getRequest<dynamic>(
      hostUrl: serverUrl,
      path: "api/payment-links/$id",
      queryParameters: {},
      accessToken: apiKey,
    );

    return jsonApiResult;
  }

  Future<dynamic?> create({
    @required Map<String, dynamic>? data,
  }) async {
    final jsonApiResult = await apiHelper.postRequest<dynamic>(
      hostUrl: serverUrl,
      path: "api/payment-links",
      data: data,
      accessToken: apiKey,
    );

    return jsonApiResult;
  }

  Future<dynamic?> update({
    @required @required Map<String, dynamic>? data,
    @required String? id,
  }) async {
    final jsonApiResult = await apiHelper.putRequest<dynamic>(
      hostUrl: serverUrl,
      path: "api/payment-links/$id",
      data: data,
      accessToken: apiKey,
    );

    return jsonApiResult;
  }

  Future<dynamic?> delete({@required String? id}) async {
    final jsonApiResult = await apiHelper.deleteRequest<dynamic>(
      hostUrl: serverUrl,
      path: "api/payment-links/$id",
      accessToken: apiKey,
    );

    return jsonApiResult;
  }
}
