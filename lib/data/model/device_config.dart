class DeviceConfig {
  String? ssid;
  String? password;
  String? fullName;
  String? contact1Name;
  String? contact1Number;
  String? contact2Name;
  String? contact2Number;
  String? contact3Name;
  String? contact3Number;

  bool get isComplete {
    return ssid != null &&
        password != null &&
        fullName != null &&
        contact1Name != null &&
        contact1Number != null &&
        contact2Name != null &&
        contact2Number != null &&
        contact3Name != null &&
        contact3Number != null;
  }

  String toFormattedString() {
    return '''
SSID: $ssid
password: $password
fullName: $fullName
contact1Name: $contact1Name
contact1Number: $contact1Number
contact2Name: $contact2Name
contact2Number: $contact2Number
contact3Name: $contact3Name
contact3Number: $contact3Number
''';
  }
}
