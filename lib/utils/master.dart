import 'constant.dart';

String formatDate(int milli) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(milli);

  String jour   = (date.day < 10 ? "0" : "") + date.day.toString();
  String mois   = Constant.moisLettres[date.month-1];
  String annee  = (date.year < 10 ? "0" : "") + date.year .toString();
  String heure  = (date.hour < 10 ? "0" : "") + date.hour .toString();
  String minute = (date.minute < 10 ? "0" : "") + date.minute .toString();

  return "$jour $mois $annee à $heure:$minute";
}