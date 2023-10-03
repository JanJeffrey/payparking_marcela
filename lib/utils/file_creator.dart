import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PayParkingFileCreator {

  final finalDirectory = '/storage/emulated/0/AndroidStudio/PayParking';
//   Future<String> get _localPath async {
//     File file = new File("/AndroidS/");
//     String folderName="files";
//     //Get this App Document Directory
//     final Directory _appDocDir = await getExternalStorageDirectory();
//  //   File dir = new File(sdcard.getAbsolutePath()+"/AndroidStudio/files/");
//    // File dir=new File(_appDocDir.get)
//     //App Document Directory + folder name
//     Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//     new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
// // The created directory is returned as a Future.
//         .then((Directory directory) {
//       print('Path of New Dir: '+directory .path);
//     });
//
//     final Directory _appDocDirFolder =
//     Directory('${appDocDirectory.path}/$folderName');
//     if (await _appDocDirFolder.exists()) {
//       //if folder already exists return path
//       print("LOCATIOON"+_appDocDirFolder.path);
//       return _appDocDirFolder.path;
//     } else {
//       //if folder not exists create folder and then return its path
//       final Directory _appDocDirNewFolder =
//       await _appDocDirFolder.create(recursive: true);
//       print("LOCATIOON"+_appDocDirFolder.path);
//       return _appDocDirNewFolder.path;
//     }
//   }
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }
  Future<File> get transactionType async {
    final path = await finalDirectory;
    return File('$path/transaction_type.txt');
  }

  Future<File> get transactions async {
    final path = await finalDirectory;
    return File('$path/transactions.txt');
  }

  Future<String> readContent() async {
    try {
      final file = await transactions;
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  Future<File> transactionTypeFunc(text) async {
    final file = await transactionType;
    final status = await file.exists();
    print('ang status kay $status');
    // Write the file

    return file.writeAsString(text);
  }

  Future<File> transactionsFunc(
      String uid,
      String checkDigitResult,
      String plateNumber,
      String dateToday,
      String dateTimeToday,
      String dateUntil,
      String amount,
      String empId,
      String locationAnew) async {
    final file = await transactions;
    // Write the file
//  String text = uid+"\n"+checkDigitResult+"\n"+plateNumber+"\n"+dateToday+"\n"+dateTimeToday+"\n"+dateUntil+"\n"+amount+"\n"+empId+"\n"+locationAnew;
    String text = uid + "\n" +
                  checkDigitResult + "\n" +
                  plateNumber + "\n" +
                  dateToday + "\n" +
                  dateTimeToday + "\n" +
                  dateToday + "\n" +
                  amount + "\n" +
                  empId + "\n" +
                  locationAnew;
    return file.writeAsString(text);
  }

  Future<File> transPenaltyFunc(
      uid, checkDigit,
      plateNumber, dateIn,
      dateNow, amountPay,
      penalty, user,
      empNameIn, outBy,
      empNameOut, location,
      penaltyOT, totalNoOfExcessHours,
      totalChargeAmount, totalNoOfHours,
      lostofticket) async {
    final file = await transactions;
    String text = dateNow +"\n" +
                  plateNumber + "\n" +
                  amountPay + "\n" +
                  checkDigit + "\n" +
                  dateIn + "\n" +
                  dateNow + "\n" +
                  penalty + "\n" +
                  penaltyOT + "\n" +
                  totalNoOfExcessHours + "\n" +
                  totalChargeAmount + "\n" +
                  totalNoOfHours + "\n" +
                  lostofticket;
    return file.writeAsString(text);
  }

  Future<File>delinquentTrans(datenow,plateNo,vtype,ticketNo,transCode,String dateTime)async{
    final file = await transactions;
    String text = datenow.toString()+"\n"+
                  plateNo.toString()+"\n"+
                  vtype.toString()+"\n"+
                  ticketNo.toString()+"\n"+
                  transCode.toString()+"\n"+
                  dateTime;
    return file.writeAsString(text);
  }
// Future<File> transPenaltyFunc2(uid,checkDigit,plateNumber,dateIn,dateNow,amountPay,penalty,user,empNameIn,outBy,empNameOut,location,penaltyOT,totalNoOfExcessHours,totalChargeAmount, totalNoOfHours) async{
//   final file = await transactions;
//   String text = dateNow+"\n"+plateNumber+"\n"+amountPay+"\n"+checkDigit+"\n"+dateIn+"\n"+dateNow+"\n"+penalty+"\n"+penaltyOT+"\n"+totalNoOfExcessHours+"\n"+totalChargeAmount+"\n"+totalNoOfHours;
//   return file.writeAsString(text);
// }
}
