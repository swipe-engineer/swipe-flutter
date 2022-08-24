class SwipeResult {
  bool paid;
  String? errorMessage;
  dynamic? data;
  dynamic messages;

  SwipeResult({this.paid = false, this.errorMessage, this.data, this.messages});
}
