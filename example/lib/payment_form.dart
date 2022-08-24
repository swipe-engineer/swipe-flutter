import 'package:example/loader.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipe/swipe.dart';

class PaymentForm extends StatefulWidget {
  String title;

  PaymentForm({this.title = "", Key? key}) : super(key: key);

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Payment Form Demo",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Email'),
              controller: emailController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              controller: titleController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Amount'),
              controller: amountController,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 160,
              height: 40,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  primary: MyApp.primarySwipeColor,
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  Swipe.testMode = false;
                  Swipe.apiKey = "62|XqZwRto0ZTi7a7ymJmzlfMwsQCbWFRPdVxdIDLPi";

                  final swipeResult = await Swipe.makePayment(
                    context: context,
                    title: titleController.text,
                    email: emailController.text,
                    amount: amountController.text,
                  );

                  setState(() {
                    loading = false;
                  });

                  if (!swipeResult.paid) {
                    Fluttertoast.showToast(
                      msg: swipeResult.errorMessage ?? "Payment Terminated.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  Fluttertoast.showToast(
                    msg: "Payment Succeed",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                child: loading
                    ? const Loader()
                    : const Text(
                        "Proceed Payment",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    titleController.dispose();
    amountController.dispose();
  }
}
