library swipe;

import 'package:flutter/material.dart';
import 'package:swipe/data/api/api_exception.dart';
import 'package:swipe/data/model/swipe_result.dart';
import 'package:swipe/data/repositories/payment_link_repository.dart';
import 'package:swipe/view/payment_webview.dart';

class Swipe {
  static String apiKey = "";
  static bool testMode = true;

  static const String serverUrl = "https://api.swipego.io/";
  static const String testServerUrl = "https://test-api.swipego.io/";

  static String getServerUrl() {
    if (testMode) {
      return testServerUrl;
    }

    return serverUrl;
  }

  static Future<SwipeResult> makePayment({
    BuildContext? context,
    @required title,
    desc,
    @required email,
    phoneNo,
    @required amount,
  }) async {
    try {
      final paymentLinkRepository = PaymentLinkRepository();

      final paymentLinkResult = await paymentLinkRepository.create(data: {
        "title": title,
        "desc": desc,
        "email": email,
        "phoneNo": phoneNo,
        "amount": amount,
        "currency": "MYR"
      });

      if (paymentLinkResult['data']['payment_url'] == null) {
        return SwipeResult(
          paid: false,
          errorMessage: "No payment url found",
          messages: null,
        );
      }

      if (context == null) {
        return SwipeResult(
          data: paymentLinkResult['data'],
          paid: false,
          errorMessage: null,
          messages: null,
        );
      }

      final paymentResult = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
          builder: (context) => PaymentWebview(
            attemptId: paymentLinkResult['data']['_id']!.toString(),
            paymentUrl: paymentLinkResult['data']['payment_url']!.toString(),
            businessId: paymentLinkResult['data']['business_id'],
          ),
        ),
      );

      return SwipeResult(
        paid: paymentResult,
        errorMessage: null,
        messages: null,
      );
    } catch (error) {
      if (error is APIException) {
        if (error.errorMessages() == null) {
          return SwipeResult(
              paid: false,
              errorMessage: error.toString(),
              messages: error.errorMessage());
        }
      }

      return SwipeResult(
        paid: false,
        errorMessage: error.toString(),
        messages: null,
      );
    }
  }
}
