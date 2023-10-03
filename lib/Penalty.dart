import 'package:intl/intl.dart';
import 'parkingTransList.dart';

class Penalty{


        int function_excessHours(){
          DateTime now = new DateTime.now();
          String timeNowHrs = DateFormat.H().format(now);
          int intTimeNowHrs = int.parse(timeNowHrs);
          String timeNowMin = DateFormat.m().format(now);
          int intTimeNowMin = int.parse(timeNowMin);
          String strtTimeNowDay = DateFormat.d().format(now);
          int intTimeNowDay = int.parse(strtTimeNowDay);
          return 0;
        }

        int function_charge(){
          return 0;
        }

        int function_penalty(){
          return 0;
        }

  /*
                      DateTime now = new DateTime.now();
                      String timeNowHrs = DateFormat.H().format(now);
                      int intTimeNowHrs = int.parse(timeNowHrs);
                      String timeNowMin = DateFormat.m().format(now);
                      int intTimeNowMin = int.parse(timeNowMin);
                      String strTimeNowDay = DateFormat.d().format(now);
                      int intTimeNowDay = int.parse(strTimeNowDay);

                      DateTime dateNow = new DateTime(now.year, now.month, now.day);
                      DateTime timeInDateNow = new DateTime(dateTimeIn.year, dateTimeIn.month, dateTimeIn.day);

                      String strTimeInHrs = DateFormat.H().format(dateTimeIn);
                      int intTimeInHrs = int.parse(strTimeInHrs);
                      String strTimeInMin = DateFormat.m().format(dateTimeIn);
                      int intTimeInMin = int.parse(strTimeInMin);
                      String strTimeInDay = DateFormat.d().format(dateTimeIn);
                      int intTimeInDay = int.parse(strTimeInDay);

                      //final numberOfDays = now.difference(dateTimeIn).inDays;
                      final numberOfDays = intTimeNowDay - intTimeInDay;


                      int penaltyAmount, excessNoOfHoursFirstDay, excessNoOfHoursLastDay, excessNoOfHoursInBetween, totalNoOfExcessHours, totalChargeAmount, excessNoOfHours;

                      if(dateNow.isAfter(timeInDateNow))
                      {
                          if(intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                          {
                            penaltyAmount = (numberOfDays + 1) * 500;
                            print("intTimeNow >= 19 == TRUE");
                          }
                          else
                          {
                            if(numberOfDays == 0)
                              {
                                penaltyAmount = 1 * 500;
                                print("numberOfDays == 0 TRUE");
                              }
                              else
                              {
                                print("numberOfDays == 0 FALSE");
                                // if(intTimeNowHrs >= 0 && intTimeNowHrs < 8)
                                // {
                                  penaltyAmount = (numberOfDays) * 500;
                                //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 TRUE");
                                // }
                                // else
                                // {
                                //   penaltyAmount = numberOfDays * 500;
                                //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 FALSE");
                                // }
                              }
                          }

                          if(numberOfDays > 2)
                          {
                              // excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              // excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              // excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                              // totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay + excessNoOfHoursInBetween) - 2;
                              // totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              // print("numberOfDays >= 2 TRUE");

                              if(intTimeNowHrs < 8)
                              {
                                  excessNoOfHours = 19 - intTimeInHrs;
                                  if(excessNoOfHours >= 2)
                                  {
                                    print("excessNoOfHours >= 2 TRUE || numberOfDays > 2");
                                    excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                    excessNoOfHoursLastDay = (19 - 7);
                                    excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                                    totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween) - 2;
                                    totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {
                                      print("excessNoOfHours >= 2 FALSE || numberOfDays > 2");
                                      totalChargeAmount = 0; //ok na
                                  }
                              }
                              else
                              {
                                  if(intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                                  {
                                      print("intTimeNowHrs >= 19 TRUE || numberOfDays > 2");
                                      excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                      excessNoOfHoursLastDay = (19 - 7);
                                      excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                                      totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {
                                      print("intTimeNowHrs >= 19 FALSE || numberOfDays > 2"); //ok
                                      excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                      excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                                      excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                                      totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                              }

                          }
                          else if(numberOfDays == 2)
                          {
                              if(intTimeNowHrs < 8)
                              {
                                  excessNoOfHours = 20 - intTimeInHrs;
                                  if(excessNoOfHours > 2)
                                  {
                                      print("excessNoOfHours >= 2 TRUE || numberOfDays == 2");
                                      totalNoOfExcessHours = (excessNoOfHours + 12) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {("excessNoOfHours >= 2 FALSE || numberOfDays == 2");
                                      totalChargeAmount = 0; //ok na
                                  }
                              }
                              else
                              {
                                  if(intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                                  {
                                    print("intTimeNowHrs >= 19 TRUE || numberOfDays == 2");
                                    excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                    excessNoOfHoursLastDay = (19 - 7);
                                    excessNoOfHoursInBetween = 12;
                                    totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                                    totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {
                                      print("intTimeNowHrs >= 19 FALSE || numberOfDays == 2"); //ok
                                      excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                      excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                                      excessNoOfHoursInBetween = 12;
                                      totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                              }
                          }
                          else
                          {
                              if(intTimeNowHrs < 8)
                              {
                                excessNoOfHours = 20 - intTimeInHrs;
                                if(excessNoOfHours > 2)
                                {
                                  print("excessNoOfHours >= 2 TRUE");
                                  totalNoOfExcessHours = excessNoOfHours - 2;
                                  totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                }
                                else
                                {
                                  print("excessNoOfHours >= 2 FALSE");
                                  totalChargeAmount = 0; //ok na
                                }
                              }
                              else
                              {
                                  if(intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                                  {
                                      print("intTimeNowHrs >= 19 TRUE");
                                      excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                      excessNoOfHoursLastDay = (19 - 7);
                                      //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                                      totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {("intTimeNowHrs >= 19 FALSE"); //ok
                                      excessNoOfHoursFirstDay = 20 - intTimeInHrs;
                                      excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                                      //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                                      totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                                      totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                              }
                          }
                      }
                      else
                      {
                            if(intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                            {
                              if((19 - intTimeInHrs) >= 2)
                                {
                                    print("19 - intTimeInHrs) >= 2 TRUE");
                                    penaltyAmount = 500;
                                    excessNoOfHours = 20 - intTimeInHrs;
                                    totalNoOfExcessHours = excessNoOfHours - 2;
                                    totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                }
                                else
                                {
                                    print("19 - intTimeInHrs) >= 2 FALSE");
                                    penaltyAmount = 500;
                                    totalChargeAmount = 0;
                                }
                            }
                            else
                            {
                                penaltyAmount = 0;
                                excessNoOfHours = intTimeNowHrs - intTimeInHrs;
                                if(excessNoOfHours >= 2)
                                {
                                  if(intTimeNowMin >= intTimeInMin)
                                  {
                                    print("intTimeNowMin >= intTimeInMin TRUE");
                                    totalNoOfExcessHours = (excessNoOfHours - 1);
                                    totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                  else
                                  {
                                    print("intTimeNowMin >= intTimeInMin FALSE");
                                    totalNoOfExcessHours = excessNoOfHours - 2;
                                    totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                                  }
                                }
                                else
                                {
                                  totalChargeAmount = 0;
                                  print("excessNoOfHours >= 2 FALSE");
                                }
                            }
                      }

   */

}