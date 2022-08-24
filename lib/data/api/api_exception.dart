import 'dart:convert';

class APIException implements Exception {
  final String? _message;
  final String? _prefix;
  final int? statusCode;

  APIException([this._message, this._prefix, this.statusCode]);

  String toString() {
    return "$_prefix$_message";
  }

  Map<String, dynamic>? errorMessages() {
    try {
      Map<String, dynamic> errorMessages = json.decode(_message!);
      if (!errorMessages.containsKey("errors")) {
        return null;
      }

      return errorMessages["errors"];
    } catch (error) {
      return null;
    }
  }

  String? errorMessage({List<dynamic>? formKeyResults}) {
    try {
      Map<String, dynamic> errorMessages = json.decode(_message!);
      if (!errorMessages.containsKey("validation_messages")) {
        return _message;
      }

      String errorMessage = "";
      if (!errorMessages.containsKey("errors")) {
        formKeyResults?.forEach((formKey) {
          errorMessages["validation_messages"].forEach((key, value) {
            if (formKey['key'] != null && formKey['key'].toString() == key) {
              errorMessage = "$value (${formKey['text']})";
              return;
            }
          });
        });

        return errorMessage.isEmpty
            ? errorMessages["validation_messages"]?.toString() ?? _message
            : errorMessage;
      }

      return errorMessages["message"] + errorMessages["errors"].keys.toString();
    } catch (error) {
      return _message;
    }
  }
}

class FetchDataException extends APIException {
  FetchDataException([String? message, statusCode])
      : super(message, "Error During Communication: ", statusCode);
}

class BadRequestException extends APIException {
  BadRequestException([message, statusCode])
      : super(message, "Invalid Request: ", statusCode);
}

class NotFoundException extends APIException {
  NotFoundException([message, statusCode])
      : super(message, "Invalid Request: ", statusCode);
}

class UnauthorisedException extends APIException {
  UnauthorisedException([message, statusCode])
      : super(message, "Unauthorised: ", statusCode);
}

class InvalidInputException extends APIException {
  InvalidInputException([String? message, statusCode])
      : super(message, "Invalid Input: ", statusCode);
}
