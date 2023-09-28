

import 'package:intl/intl.dart';

class DateFunctions {

  Map convertdate(stringdate){
    Map formatteddatevalues = {};
    DateTime datetime = DateTime.parse(stringdate);
    formatteddatevalues = {
      'dayofweek': DateFormat('EEEE').format(datetime),
      'date': DateFormat('dd/MM/yy').format(datetime),
      'normalized': DateFormat('d MMMM yyyy').format(datetime),
    };
    return formatteddatevalues;
  }

  String determineanniversarycount(number){

    if (number == 0){
      return "1st";
    } else
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    } else {
      switch (number % 10) {
        case 1:
          return '${number}st';
        case 2:
          return '${number}nd';
        case 3:
          return '${number}rd';
        default:
          return '${number}th';
      }
    }
  }

}