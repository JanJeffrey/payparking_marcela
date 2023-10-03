import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PayparkingFileCreator2{


  Future<String> createFolderInAppDocDir(String folderName) async {
    File file = new File("");
    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
    Directory('${_appDocDir.path}/$folderName/');
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  List<FileSystemEntity> _folders;
  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = new Directory(pdfDirectory);
    // setState(() {
    //   _folders = myDir.listSync(recursive: true, followLinks: false);
    // });
    print(_folders);
  }
}