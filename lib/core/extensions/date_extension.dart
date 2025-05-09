import 'package:easy_localization/easy_localization.dart';

final todayDate = DateTime.now();
String get time => DateTime.now().toString();

Stream<String> get timeUpdate async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield time;
  }
}

String dateToReadableString(DateTime date, String dateFormat) {
  var result = "";
  try {
    result = DateFormat(dateFormat).format(date);
  } catch (e) {
    result;
  }
  return result;
}

DateTime stringToDateNoFormatter(String valueDate) {
  var result = DateTime.now();
  try {
    result = DateTime.parse(valueDate);
  } catch (e) {
    result;
  }
  return result;
}

DateTime stringToDate(String valueDate, String dateFormat) {
  var result = DateTime.now();
  try {
    result = DateTime.parse(valueDate);
  } catch (e) {
    result;
  }
  return result;
}

DateTime stringNullableToDate(String? valueDate, String dateFormat) {
  var result = DateTime.now();
  try {
    if (valueDate == null) {
      result;
    } else {
      result = DateTime.parse(valueDate.isEmpty.toString());
    }
  } catch (e) {
    result;
  }
  return result;
}

int getTotalMonthBetweenDates(DateTime startDate, DateTime endDate) {
  int totalMonths =
      (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;

  if (startDate.day > endDate.day) {
    totalMonths--;
  } else if (startDate.day == endDate.day && startDate.hour > endDate.hour) {
    totalMonths--;
  }
  return totalMonths;
}

bool isShowAsiExclusive(DateTime birthDate, DateTime eventDate) {
  final targetDate = DateTime(
    birthDate.year,
    birthDate.month + 6,
    birthDate.day,
    birthDate.hour,
    birthDate.minute,
    birthDate.second,
    birthDate.second,
  );
  if (eventDate.isAfter(targetDate)) {
    return false;
  } else {
    return true;
  }
}

class DateHelper {
  String formmateSlashString(String value) {
    String result = value;
    try {
      result = value.replaceAll('-', ' / ');
    } catch (e) {
      result = value;
    }

    return result;
  }

  DateTime formmateSlashDate(String value) {
    DateTime result;
    try {
      result = DateTime.parse(value.split('-').reversed.join());
    } catch (e) {
      result = DateTime.now();
    }

    return result;
  }

  String formattedDateStringSlash(String value) {
    String result = '';
    try {
      DateTime formmater = DateTime.parse(value.split(' / ').reversed.join());
      result = DateFormat('dd / MM / yyyy').format(formmater);
    } catch (e) {
      result;
    }

    return result;
  }

  String formmateServerSlashWithSpaceDate(String value) {
    String result = '';
    try {
      DateTime formmater = DateTime.parse(value.split(' / ').reversed.join());
      result = DateFormat('yyyy-MM-dd').format(formmater);
    } catch (e) {
      result;
    }

    return result;
  }
}

extension DateTimeExtension on DateTime {
  String toIndonesianCommon() {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(this);
  }

  String toEnglishCommon() {
    return DateFormat('dd MMMM yyyy').format(this);
  }

  String toAbbreviationCommon() {
    return DateFormat.yMMMMd().format(this);
  }

  String toMonthlyYear() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String toMonthly() {
    return DateFormat('dd MMM').format(this);
  }

  String toSlashSeparated() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toStripID() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toStrip() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String toStrip2() {
    return DateFormat('MM-dd-yyyy').format(this);
  }

  String toApiFormatter() {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(this);
  }

  String toDaysIndonesiaFormat() {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(this);
  }

  String toDaysEnglishFormat() {
    return DateFormat('EE, dd MMMM yyyy', 'en_EN').format(this);
  }

  String toIndonesiaDatetime() {
    return DateFormat('dd MMMM yyyy | HH:mm', 'id_ID').format(this);
  }

  String toEnglishTime() {
    return DateFormat('EEEE, dd MMMM yyyy | HH:mm', 'en_EN').format(this);
  }

  String toTime() {
    return DateFormat('HH:mm', 'en_EN').format(this);
  }

  String toAMPM() {
    return DateFormat('HH:mm a', 'en_EN').format(this);
  }

  String toMonth() {
    return DateFormat('MMMM', 'en_EN').format(this);
  }

  String toMonthYear() {
    return DateFormat('MMMM yyyy', 'en_EN').format(this);
  }

  String toTimeHHMM() {
    return DateFormat('HH:mm', 'en_EN').format(this);
  }
}

extension StringDateExtension on String {
  DateTime fromIndonesianCommonToDateTime() {
    return DateFormat('dd MMMM yyyy', 'id_ID').parse(this);
  }

  DateTime fromSlashSeparatedToDateTime() {
    return DateFormat('d/MM/yyyy', 'id_ID').parse(this);
  }

  DateTime fromApiFormat() {
    return DateFormat(
      'yyyy-MM-ddTHH:mm:ss.SSS',
    ).parse(this, true);
  }

  DateTime fromApiFormat3() {
    return DateFormat(
      'yyyy-MM-dd',
    ).parse(this, true);
  }

  DateTime toStrip() {
    return DateFormat('dd-MM-yyyy').parse(this);
  }

  DateTime toStripYMD() {
    return DateFormat('yyyy-MM-dd').parse(this);
  }

  DateTime fromApiFormat2() {
    return DateFormat(
      "yyyy-MM-ddTHH:mm:ssZ",
    ).parse(this, true);
  }

  DateTime toTime() {
    return DateFormat('HH:mm', 'en_EN').parse(this);
  }

  DateTime toAMPM() {
    return DateFormat('HH:mm a', 'en_EN').parse(this);
  }
}

extension GreetingExtension on DateTime {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}
