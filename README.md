
Flutter OTP Field is a Flutter package that provides a customizable widget for entering OTP (One-Time Password) in Flutter applications. It allows users to easily input OTP codes with various customization options like background color, border styles, text styles, and more.

- Input OTP codes easily with a customizable OTP field widget.
- Customize the appearance of the OTP field including background color, border styles, text styles, and more.
- Supports automatic focusing on the OTP field for a seamless user experience.
- Includes a "Paste" button for quickly pasting OTP codes from the clipboard.
- Allows handling of OTP code changes and completion events with callback functions.

## Installation
To use Flutter OTP Field in your Flutter project, follow these steps:

1. Add the dependency to your `pubspec.yaml` file:

```dart
dependencies:
  otp_field_flutter: ^1.0.0
```
2. Run `flutter pub get` to install the package.

## Usage
To use the Flutter OTP Field widget in your Flutter application, import the package and use the FlutterOTPField widget with desired customization options. Here's a basic example:

```dart
import 'package:flutter/material.dart';
import 'package:otp_field_flutter/otp_field_flutter.dart';

class MyOTPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: FlutterOTPField(
          length: 6,
          onCompleted: (String otp) {
            // Handle OTP verification here
            print('Entered OTP: $otp');
          },
        ),
      ),
    );
  }
}
```

## Customization

You can customize the appearance and behavior of the OTP field using various properties available in the `FlutterOTPField` widget. Some of the customizable options include:

- `backgroundColor`: Background color of the OTP field.
- `borderColor`: Border color of the OTP field.
- `length`: Length of the OTP code.
- `onCompleted`: Callback function triggered when OTP entry is completed.

For a full list of customizable options, refer to the source code.

## Contributing
Contributions to Flutter OTP Field are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on GitHub.

## LICENSE
This package is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License. See the LICENSE file for more details.

## Author
Flutter OTP Field is developed and maintained by [shihabkarimba](https://github.com/shihabkarimba).

## Resources
- [Github Repository](https://github.com/shihabkarimba/otp_field_flutter)
- [Pub.dev]()

## Version History
- `0.0.1`: Initial release.