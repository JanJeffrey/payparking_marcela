import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payparkingv3/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PayParkingDatabase {
  static final PayParkingDatabase _instance = PayParkingDatabase._();
  static Database _database;

  // //LIVE DATABASE(ALTA CITTA)...
  // static String dbSource = "http://172.16.174.201:81";
  // //LIVE DATABASE(MARCELA)...
  // static String dbSource = "http://172.16.174.201:81";
  // static String dbSource = "http://172.16.176.20"; // og mag live e uncomment rani duha.
  // static String bertingserver = "e_parking/";
  //LOCAL DATABASE(MARCELA)...
  //static String dbSource = "http://172.16.43.7:8080";
  static String dbSource = "http://172.16.46.128:81";
  static String bertingserver = "";
  // static String dbSource = "http://172.16.46.128:81";
  // static String bertingserver = "";
  //jay local
  // static String dbSource = "http://172.16.43.168";

  PayParkingDatabase._();

  factory PayParkingDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();
    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'payparking.db');

    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE tbl_oftransactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        checkDigit TEXT,
        plateNumber TEXT,
        dateToday TEXT,
        dateTimeToday TEXT,
        dateUntil TEXT,
        amount TEXT,
        empId TEXT,
        fname TEXT,
        status TEXT,
        location TEXT
        )''');

    db.execute('''
      CREATE TABLE payparhistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        checkDigit TEXT,
        plateNumber TEXT,
        dateTimein TEXT,
        dateTimeout TEXT,
        amount TEXT,
        penalty TEXT,
        user TEXT,
        empNameIn TEXT,
        outBy TEXT,
        empNameOut TEXT,
        location TEXT,
        delStatus TEXT,
        penaltyOT TEXT,
        totalExcess TEXT,
        totalCharge TEXT,
        status TEXT,
        totalNoOfHours TEXT,
        lostOfTicket TEXT
        )''');

    db.execute('''
      CREATE TABLE tbl_users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        empid TEXT,
        fullname TEXT,
        username TEXT,
        password TEXT,
        usertype TEXT,
        status TEXT
        )''');
    db.execute('''
      CREATE TABLE tbl_manager(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        empId TEXT,
        username TEXT,
        password TEXT,
        usertype TEXT,
        status TEXT
        )''');

    db.execute('''
      CREATE TABLE tbl_usersLocationUser(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locUserId TEXT,
        userId TEXT,
        locationId TEXT,
        empId TEXT
        )''');

    db.execute('''
      CREATE TABLE tbl_location(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        locationId TEXT,
        location TEXT,
        locationaddress TEXT,
        status TEXT
        )''');

    db.execute('''
      CREATE TABLE synchistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        syncDate TEXT
        )''');

    db.execute('''
      CREATE TABLE tbl_delinquent(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        plateno TEXT,
        dateToday TEXT,
        empName TEXT,
        secNameC TEXT,
        imgEmp TEXT,
        penaltyA TEXT,
        totCharge TEXT,
        totalAmt TEXT,
        dateEscaped TEXT
        )''');
    db.execute('''
      CREATE TABLE tbl_delinquent2(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        plateNo TEXT,  
        dateToday TEXT,
        fullName TEXT,
        secNameC TEXT,
        imgEmp TEXT,
        imgGuard TEXT,
        penaltyA TEXT,
        totCharge TEXT,
        totAmt TEXT,
        dateEscaped TEXT,
        status TEXT,
        dateTimeIn TEXT,
        checkdigit TEXT,
        vtype TEXT,
        totalHrs TEXT,
        excessHrs TEXT
        )''');
    db.execute('''
      CREATE TABLE tbl_delinquent3(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        plateNo TEXT, 
        vtype TEXT,
        transcode TEXT,
        datetime TEXT,
        penalty TEXT
        )''');
    db.execute('''CREATE TABLE tbl_login_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emp_id TEXT,
        emp_name TEXT,
        datelogin TEXT,
        timelogin TEXT,
        datelogout TEXT,
        timelogout TEXT)''');

    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> ofSaveTransaction(
      String uid,
      String checkDigitResult,
      String plateNumber,
      String dateToday,
      String dateTimeToday,
      String dateUntil,
      String amount,
      String empId,
      String fName,
      int stat,
      String locationAnew) async {
    var client = await db;
    return client.insert('tbl_oftransactions', {
      'uid'           : uid,
      'checkDigit'    : checkDigitResult,
      'plateNumber'   : plateNumber,
      'dateToday'     : dateToday,
      'dateTimeToday' : dateTimeToday,
      'dateUntil'     : dateUntil,
      'amount'        : amount,
      'empId'         : empId,
      'fname'         : fName,
      'status'        : stat,
      'location'      : locationAnew
    });
  }

  Future ofFetchAll() async {
    var client = await db;
    //return client.query('tbl_oftransactions', where: 'status = ? and location = ?'  ,whereArgs: ['1',location] );
    return client.rawQuery(
        'SELECT * FROM tbl_oftransactions WHERE status ="1"', null);
  }

  Future ofSaveUsers(
      uid, empId, fullName, userName, password, userType, status) async {
    var client = await db;
    return client.insert('tbl_users', {
      'uid'     : uid,
      'empid'   : empId,
      'fullname': fullName,
      'username': userName,
      'password': password,
      'usertype': userType,
      'status'  : status
    });
  }

  Future ofSaveLocationUsers(locUserId, userId, locationId, empId) async {
    var client = await db;
    return client.insert('tbl_usersLocationUser', {
      'locUserId' : locUserId,
      'userId'    : userId,
      'locationId': locationId,
      'empId'     : empId
    });
  }

  Future ofSaveLocation(locationId, location, locationAddress, status) async {
    var client = await db;
    return client.insert('tbl_location', {
      'locationId'      : locationId,
      'location'        : location,
      'locationaddress' : locationAddress,
      'status'          : status
    });
  }

  Future ofSaveManagers(empId, username, password, userType, status) async {
    var client = await db;
    return client.insert('tbl_manager', {
      'empId'   : empId,
      'username': username,
      'password': password,
      'usertype': userType,
      'status'  : status,
    });
  }

  Future ofFetchSearch(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tbl_oftransactions WHERE plateNumber LIKE '%$text%' AND status ='1'",
        null);
  }

  Future validatePlateNumber(plateNumber) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tbl_delinquent WHERE plateno LIKE '%$plateNumber%'",
        null);
  }



  Future<int> updatePayTranStat(int id) async {
    var client = await db;
    return client.update('tbl_oftransactions', {'status': '0'},
        where: 'id = ?', whereArgs: [id]);
  }

  Future ofUpdateTransaction(int id, String plateNumber) async {
    var client = await db;
    return client.update('tbl_oftransactions', {'plateNumber': plateNumber},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List> fetchSync() async {
    var client = await db;
    return client.query('synchistory ORDER BY id DESC LIMIT 1');
  }

  Future<int> insertSyncDate(String date) async {
    var client = await db;
    return client.insert('synchistory', {'syncDate': date});
  }

  Future<List> fetchAllHistory() async {
    var client = await db;
    return await client.query('payparhistory ORDER BY id DESC');
  }

  Future<List> fetchAllHistoryfromSqlite() async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM payparhistory WHERE delStatus LIKE '0' ORDER BY id DESC",
        null);
  }

  Future<List>fetchAllDelinquent()async{
    var client= await db;
    return client.query('tbl_delinquent2 ORDER BY id DESC');
  }

  Future<List>fetchBlacklisted(plateNumber)async{
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tbl_delinquent3 WHERE plateNo LIKE '%$plateNumber%'",
        null);
    // var client = await db;
    // return client.query('tbl_delinquent3');
  }
  Future<List>syncBlaclisted()async{
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tbl_delinquent3",
        null);
    // var client = await db;
    // return client.query('tbl_delinquent3');
  }

//0=not deleted 1=deleted
  Future updateHistory() async {
    var client = await db;
    return client.update('payparhistory', {'delStatus': '1'},
        where: 'delStatus=0');
  }

  Future ofFetchSearchHistory(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM payparhistory WHERE plateNumber LIKE '%$text%' and delStatus = 0", null);
  }

  Future<int> addTransHistory(
      String uid,
      checkDigit,
      String plateNumber,
      String dateIn,
      String dateNow,
      String amountPay,
      String penalty,
      String user,
      String empNameIn,
      String outBy,
      String empNameOut,
      String location,
      String penaltyOT,
      String totalNoOfExcessHours,
      String totalChargeAmount,
      String status,
      String totalNoOfHours,
      String lostOfTicket) async {
    var client = await db;
    return client.insert('payparhistory', {
      'uid'           : uid,
      'checkDigit'    : checkDigit,
      'plateNumber'   : plateNumber,
      'dateTimein'    : dateIn,
      'dateTimeout'   : dateNow,
      'amount'        : amountPay,
      'penalty'       : penalty,
      'user'          : user,
      'empNameIn'     : empNameIn,
      'outBy'         : outBy,
      'empNameOut'    : empNameOut,
      'location'      : location,
      'delStatus'     : '0',
      'penaltyOT'     : penaltyOT,
      'totalExcess'   : totalNoOfExcessHours,
      'totalCharge'   : totalChargeAmount,
      'status'        : status,
      'totalNoOfHours': totalNoOfHours,
      'lostOfTicket'  : lostOfTicket
    });
  }

  Future emptyHistoryTbl() async {
    var client = await db;
    return client.rawQuery("DELETE FROM payparhistory");
  }

  Future emptyUserTbl() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_users");
  }

  Future emptyLocationUserTbl() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_usersLocationUser");
  }

  Future emptyLocationTbl() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_location");
  }

  Future emptyManagerTbl() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_manager");
  }

  Future emptyDelinquent() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_delinquent");
  }
  Future emptytblDelinquent3() async {
    var client = await db;
    return client.rawQuery("DELETE FROM tbl_delinquent3");
  }

  Future<int> getCounter() async {
    //database connection
    var client = await db;
    int count = Sqflite.firstIntValue(await client
        .rawQuery('SELECT COUNT(*) FROM payparhistory WHERE delStatus = 0'));
    return count;
  }

  Future ofLogin(username, password) async {
    var client = await db;
    var passwordF = md5.convert(utf8.encode(password));
    var res = client.rawQuery(
        "SELECT * FROM tbl_users WHERE username = '$username' AND password = '$passwordF'",
        null);
    return res;
  }

  Future ofCountFetchUserData() async {
//    var client = await db;
//    var count = client.rawQuery("SELECT COUNT(*) as count, group_concat(locationId) as location_id ,fullname,user.empid as userEmpID,username FROM tbl_usersLocationUser as userloc INNER JOIN tbl_users as user ON userloc.userId = user.uid WHERE user.empId = '$userId'",null);
//    return count;
    var client = await db;
    var count =
        client.rawQuery("SELECT COUNT(*) as count FROM tbl_location", null);
    return count;
  }

  Future ofGetUsername(empId) async {
    var client = await db;
    var res = client.rawQuery("SELECT * from tbl_users WHERE empid = '$empId'");
    return res;
  }

  Future ofFetchUserData() async {
    var client = await db;
//    var res = client.rawQuery("SELECT * FROM tbl_usersLocationUser as userloc INNER JOIN tbl_location as loc ON loc.locationId = userloc.locUserId  INNER JOIN tbl_users as users ON users.empid = userloc.empId WHERE users.empid = '$userId'");
    var res = client.rawQuery("SELECT location from tbl_location");
    return res;
  }

  Future ofSaveDelinquent(uid, plateNo, date, appUser, manager, signImg,
      penaltyA, totCharge, totAmt, dateEscaped) async {
    var client = await db;
    return client.insert('tbl_delinquent', {
      'uid'         : uid,
      'plateno'     : plateNo,
      'dateToday'   : date,
      'empName'     : appUser,
      'secNameC'    : manager,
      'imgEmp'      : signImg,
      'penaltyA'    : penaltyA,
      'totCharge'   : totCharge,
      'totalAmt'    : totAmt,
      'dateEscaped' : dateEscaped
    });
  }

  Future saveLogInDataToSqlite(empid,empname,datelogin,timelogin)async{
    var client=await db;
    return client.insert('tbl_login_data', {
      'emp_id'    :empid.toString(),
      'emp_name'  :empname.toString(),
      'datelogin' :datelogin.toString(),
      'timelogin' :timelogin.toString()
    });
  }
  Future saveLogOutDataToSqlite(){

  }
  Future ofManagerLogin(username, password) async {
    var client = await db;
    var passwordF = md5.convert(utf8.encode(password));
    var res = client.rawQuery(
        "SELECT * FROM tbl_manager WHERE username = '$username' AND password = '$passwordF'",
        null);
    return res;
  }

  //mysql query code
  Future countTblUser() async {
    var dataUser;
    final response = await http.post(
        Constants.dbSource + "/${Constants.bertingserver}app_countDataDownload",
        body: {});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future countTblLocationUser() async {
    var dataUser;
    final response = await http.post(
        Constants.dbSource + "/${Constants.bertingserver}app_countLocationUser",
        body: {});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future countTblLocation() async {
    var dataUser;
    final response = await http
        .post(Constants.dbSource + "/${Constants.bertingserver}app_countLocation", body: {});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future countTblManager() async {
    var dataUser;
    final response = await http
        .post(Constants.dbSource + "/${Constants.bertingserver}app_countTblManager", body: {});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future countTblDelinquent() async {
    var dataUser;
    final response = await http.post(
        Constants.dbSource + "/${Constants.bertingserver}app_countTblDelinquent",
        body: {});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }
  Future saveLogInData(empid,emp_name,datelogin,datelogout,status)async{
    await http.post(
        Constants.dbSource + "/${Constants.bertingserver}saveLogInData",body:{
          "emp_id"    :empid.toString(),
          "emp_name"  :emp_name.toString(),
          "datelogin" :datelogin.toString(),
        //  "timelogin" :timelogin.toString(),
          "datelogout":datelogout.toString(),
      //    "timelogout":timelogout.toString(),
          "status"    :status.toString()
    });
  }
  Future saveLogOutData(dateTimeLogout)async{
    await http.post(Constants.dbSource + "/${Constants.bertingserver}saveLogOutData",body: {
      "datelogout"  : dateTimeLogout.toString()
      //"timelogout"  : timelogout.toString()
    });
  }
  Future olSaveDelinquent(id, uid, plateNo, dateToday, fullName, secNameC,
      imgEmp, imgGuard, penaltyA, totCharge, totAmt, dateEscape,dateTimeIn,checkdigit,vtype,totafhours,excess) async {
    // await http.post(Constants.dbSource + "/e_parking/olSaveDelinquent", body: {
    //   "id"          : id.toString(),
    //   "uid"         : uid.toString(),
    //   "plateNo"     : plateNo.toString(),
    //   "dateToday"   : dateToday.toString(),
    //   "fullName"    : fullName.toString(),
    //   "secNameC"    : secNameC.toString(),
    //   "imgEmp"      : imgEmp.toString(),
    //   "imgGuard"    : imgGuard.toString(),
    //   "penaltyA"    : penaltyA.toString(),
    //   "totCharge"   : totCharge.toString(),
    //   "totAmt"      : totAmt.toString(),
    //   "dateEscaped" : dateEscape.toString()
    // });
    await http.post(
                Constants.dbSource + "/${Constants.bertingserver}olSaveDelinquent", body: {
                  "id"         : id.toString(),
                  "uid"        : uid.toString(),
                  "plateNo"    : plateNo.toString(),
                  "dateToday"  : dateToday.toString(),
                  "fullName"   : fullName.toString(),
                  "secNameC"   : secNameC.toString(),
                  "imgEmp"     : imgEmp.toString(),
                  "imgGuard"   : imgGuard.toString(),
                  "penaltyA"   : penaltyA.toString(),
                  "totCharge"  : totCharge.toString(),
                  "totAmt"     : totAmt.toString(),
                  "dateEscaped": dateEscape.toString(),
                  "status"     : 'unpaid',
                  "datetime"   : dateTimeIn.toString(),
                  "transcode"  : checkdigit.toString(),
                  "vtype"      : vtype.toString(),
                  "totalHrs"   : totafhours.toString(),
                  "excessHrs"  : excess.toString()
            });
  }

  Future saveDelinquentToSqlite(id, uid, plateNo, dateToday, fullName, secNameC,
      imgEmp, imgGuard, penaltyA, totCharge, totAmt, dateEscape,dateTimeIn,checkdigit,vtype,totafhrs,excess) async {
    var client = await db;
    return client.insert('tbl_delinquent2', {
      'id'          : id.toString(),
      'uid'         : uid.toString(),
      'plateNo'     : plateNo.toString(),
      'dateToday'   : dateToday.toString(),
      'fullName'    : fullName.toString(),
      'secNameC'    : secNameC.toString(),
      'imgEmp'      : imgEmp.toString(),
      'imgGuard'    : imgGuard.toString(),
      'penaltyA'    : penaltyA.toString(),
      'totCharge'   : totCharge.toString(),
      'totAmt'      : totAmt.toString(),
      'dateEscaped' : dateEscape.toString(),
      'dateTimeIn'  : dateTimeIn.toString(),
      'checkdigit'  : checkdigit.toString(),
      'vtype'       : vtype.toString(),
      'status'      : 'unpaid',
      'totalHrs'    : totafhrs.toString(),
      'excessHrs'   : excess.toString()
    });
  }

  Future delinquentTrans(String ticketNo,String plateno,String vtype,String transcode,String datetime)async{
    var client = await db;
    return client.insert('tbl_delinquent3',{
      'uid'       :ticketNo,
      'plateNo'   :plateno,
      'vtype'     :vtype,
      'transcode' :transcode,
      'datetime'  :datetime,
      'penalty'   :500
    });
  }
  //=====================
  Future mysqlLogin(username, password) async {
    final response =
        await http.post("http://172.16.46.130" + "/e_parking/app_login", body: {
      "username": username,
      "password": password,
    });
    if (response.body.length >= 1 && response.statusCode == 200) {
      return response.body;
    } else {
      return 'error';
    }
  }

  Future olFetchUserData(userId) async {
    Map dataUser;
    final response = await http
        .post("http://172.16.46.130" + "/e_parking/app_getUserData", body: {
      "userId": userId,
    });
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future olSaveTransaction(uid, checkDigitResult, plateNumber, dateToday,
      dateTimeToday, dateUntil, amount, user, stat, location) async {
    await http
        .post("http://172.16.46.130" + "/e_parking/olSaveTransaction", body: {
      'uid': uid.toString(),
      'checkDigitResult': checkDigitResult.toString(),
      'plateNumber': plateNumber.toString(),
      'dateToday': dateToday.toString(),
      'dateTimeToday': dateTimeToday.toString(),
      'dateUntil': dateUntil.toString(),
      'amount': amount.toString(),
      'user': user.toString(),
      'stat': stat.toString(),
      'location': location.toString(),
    });
  }

  Future olFetchAll(location) async {
    Map dataUser;
    final response = await http.post(
        "http://172.16.46.130" + "/e_parking/appGetTransaction",
        body: {'location': location.toString()});
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future olAddTransHistory(id, uid, checkDigit, plateNumber, dateIn, dateNow,
      amountPay, penalty, user, outBy, location) async {
    await http
        .post("http://172.16.46.130" + "/e_parking/appSaveToHistory", body: {
      'id': id.toString(),
      'uid': uid.toString(),
      'checkDigit': checkDigit.toString(),
      'plateNumber': plateNumber.toString(),
      'dateIn': dateIn.toString(),
      'dateNow': dateNow.toString(),
      'amountPay': amountPay.toString(),
      'penalty': penalty.toString(),
      'user': user.toString(),
      'outBy': outBy.toString(),
      'location': location.toString(),
    });
  }

  Future olUpdateTransaction(id, plateNumber, wheel, locationA) async {
    await http
        .post("http://172.16.46.130" + "/e_parking/appUpdateTrans", body: {
      'id': id.toString(),
      'plateNumber': plateNumber.toString(),
      'wheel': wheel.toString(),
      'locationA': locationA.toString(),
    });
  }

  Future trapLocation(id) async {
    final response = await http
        .post("http://172.16.46.130" + "/e_parking/trapLocation", body: {
      "id": id.toString(),
    });
    if (response.body.toString() == 'true') {
      return true;
    } else {
      return false;
    }
  }

  Future olFetchSearch(text, location) async {
    Map dataUser;
    final response = await http
        .post("http://172.16.46.130" + "/e_parking/olFetchSearch", body: {
      "text": text.toString(),
      "location": location.toString(),
    });
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future olFetchSearchHistory(text, location) async {
    Map dataUser;
    final response = await http.post(
        "http://172.16.46.130" + "/e_parking/olFetchSearchHistory",
        body: {
          "text": text.toString(),
          "location": location.toString(),
        });
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future olFetchHistory(location) async {
    Map dataUser;
    final response = await http
        .post("http://172.16.46.130" + "/e_parking/olFetchHistory", body: {
      "location": location.toString(),
    });
    dataUser = jsonDecode(response.body);
    return dataUser;
  }

  Future olManagerLogin(username, password) async {
    final response = await http
        .post("http://172.16.46.130" + "/e_parking/olManagerKey", body: {
      "username": username,
      "password": password,
    });
    if (response.body.length >= 1 && response.statusCode == 200) {
      return response.body;
    } else {
      return 'error';
    }
  }

  Future olSendTransType(empId, type) async {
    await http
        .post("http://172.16.46.130" + "/e_parking/olSendTransType", body: {
      "empId": empId,
      "type": type,
    });
  }

  Future olReprintCouponTicket(uid, checkDigit, plateNo, dateToday,
      dateTimeToday, dateUntil, amount, empId, location) async {
    await http.post("http://172.16.46.130" + "/e_parking/olReprintCouponTicket",
        body: {
          'uid': uid.toString(),
          'checkDigit': checkDigit.toString(),
          'plateNo': plateNo.toString(),
          'dateToday': dateToday.toString(),
          'dateTimeToday': dateTimeToday.toString(),
          'dateUntil': dateUntil.toString(),
          'amount': amount.toString(),
          'empId': empId.toString(),
          'location': location.toString(),
        });
  }

  Future olCancel(id) async {
    await http.post("http://172.16.46.130" + "/e_parking/olCancel", body: {
      'id': id.toString(),
    });
  }

  Future olPenaltyReprint(uId, transCode, plate, dateTimeIn, dateTimeout,
      amount, penalty, inEmpId, outEmpId, location) async {
    await http
        .post("http://172.16.46.130" + "/e_parking/olPenaltyReprint", body: {
      'uId': uId.toString(),
      'transCode': transCode.toString(),
      'plate': plate.toString(),
      'dateTimeIn': dateTimeIn.toString(),
      'dateTimeout': dateTimeout.toString(),
      'amount': amount.toString(),
      'penalty': penalty.toString(),
      'inEmpId': inEmpId.toString(),
      'outEmpId': outEmpId.toString(),
      'location': location.toString(),
    });
  }

//  Future<Car> fetchCar(int id) async {
//    var client = await db;
//    final Future<List<Map<String, dynamic>>> futureMaps = client.query('car', where: 'id = ?', whereArgs: [id]);
//    var maps = await futureMaps;
//
//    if (maps.length != 0) {
//      return Car.fromDb(maps.first);
//    }
//
//    return null;
//  }
//
//  Future<List<Car>> fetchAll() async {
//    var client = await db;
//    var res = await client.query('car');
//
//    if (res.isNotEmpty) {
//      var cars = res.map((carMap) => Car.fromDb(carMap)).toList();
//      return cars;
//    }
//    return [];
//  }
//
//  Future<int> updateCar(Car newCar) async {
//    var client = await db;
//    return client.update('car', newCar.toMapForDb(),
//        where: 'id = ?', whereArgs: [newCar.id], conflictAlgorithm: ConflictAlgorithm.replace);
//  }
//
//  Future<void> removeCar(int id) async {
//    var client = await db;
//    return client.delete('car', where: 'id = ?', whereArgs: [id]);
//  }
//
//  Future closeDb() async {
//    var client = await db;
//    client.close();
//  }
}
