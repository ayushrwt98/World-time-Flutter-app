import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  late String time;
  String flag;
  String url;
  late bool isDaytime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      var response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'];
      String sign = offset[0]; // Get the sign (+ or -)
      int hours = int.parse(offset.substring(1, 3)); // Extract hours
      int minutes = int.parse(offset.substring(4, 6));
      DateTime now = DateTime.parse(datetime);
      if (sign == '+') {
        now = now.add(Duration(hours: hours, minutes: minutes));
      } else if (sign == '-') {
        now = now.subtract(Duration(hours: hours, minutes: minutes));
      }

      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;

      time = DateFormat.jm().format(now);
    } catch (e) {
      time = 'Could not get time Data';
    }
  }
}
