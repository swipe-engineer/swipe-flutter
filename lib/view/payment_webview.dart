import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:swipe/view/line_progress_bar.dart';
import 'package:swipe/swipe.dart';
import 'package:swipe/view/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebview extends StatefulWidget {
  final String attemptId;
  final String paymentUrl;
  final int businessId;

  const PaymentWebview(
      {Key? key,
      this.attemptId = "",
      this.paymentUrl = "",
      this.businessId = 0})
      : super(key: key);

  @override
  PaymentWebviewState createState() => PaymentWebviewState();
}

class PaymentWebviewState extends State<PaymentWebview> {
  double progress = 0.0;
  final String PUSHER_KEY = '6a2f9c1f2cdac3ddbd3d';
  final String PUSHER_CLUSTER = 'ap1';
  final BEARER_TOKEN = Swipe.apiKey;
  final String AUTH_URL = '${Swipe.serverUrl}api/broadcasting-integration/auth';
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  bool loadingPusher = true;
  String? pusherError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => initPusher());
  }

  void initPusher() async {
    try {
      await pusher.init(
        useTLS: true,
        apiKey: PUSHER_KEY,
        cluster: PUSHER_CLUSTER,
        onEvent: (PusherEvent event) {
          final data = json.decode(event.data);
          if (event.eventName == "business.payment_create" &&
              data["payment"] != null &&
              data["payment"]["payment_link_id"] == widget.attemptId) {
            Navigator.pop(context, true);
          }
        },
        onConnectionStateChange:
            (dynamic currentState, dynamic previousState) {},
        onError: (String message, int? code, dynamic e) {
          setState(() {
            loadingPusher = false;
            pusherError = message;
          });
        },
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          setState(() {
            loadingPusher = false;
          });
        },
        onSubscriptionError: (String message, dynamic e) {
          setState(() {
            loadingPusher = false;
            pusherError = message;
          });
          debugPrint('subs error $message');
          debugPrint('subs error detail ${e.toString()}');
        },
        onDecryptionFailure: (String event, String reason) {},
        onMemberAdded: (String channelName, PusherMember member) {},
        onMemberRemoved: (String channelName, PusherMember member) {},
      );

      await pusher.subscribe(channelName: "business.${widget.businessId}");
      await pusher.connect();
    } catch (e) {
      setState(() {
        loadingPusher = false;
        pusherError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    pusher.unsubscribe(channelName: "business.${widget.businessId}");
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _showCloseConfirmationDialog();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Secure Payment"),
              IconButton(
                onPressed: () {
                  _showCloseConfirmationDialog();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          bottom: LineProgressBar(
            progressValue: progress,
          ),
        ),
        body: (loadingPusher)
            ? const Center(
                child: Loader(),
              )
            : (pusherError != null)
                ? Center(child: Text(pusherError!))
                : WebView(
                    initialUrl: widget.paymentUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onProgress: (int progress) {
                      setState(() {
                        this.progress = (progress < 100)
                            ? progress.toDouble() / 100.0
                            : 0.0;
                      });
                    },
                  ),
      ),
    );
  }

  Future<void> _showCloseConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure want to terminate this payment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
