// import 'dart:io';

// import 'package:get_storage/get_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:simple/main.dart';

// class Utils {
//   static Future<String> getFileUrl(String fileName) async {
//     final directory = await getApplicationDocumentsDirectory();
//     return "${directory.path}/$fileName";
//   }
// }

// final Thing thing = Thing._private();

// class Thing {
//   Thing._private() {
//     getTemporaryDirectory()
//         .then((value) => {GetStorage("ApiDatanew", value.path)});
//   }

//   var box = GetStorage();

//   fetchPath() async {
//     getTemporaryDirectory()
//         .then((value) => value.list(recursive: true).forEach((element) {
//               print(element.absolute.path);
//             }));
//   }
// }
