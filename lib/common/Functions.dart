import "package:intl/intl.dart";

class Functions {
  static String dateToString(DateTime date) {
    DateFormat formatter = DateFormat('yyyy年MM月dd日');
    String formatted = formatter.format(date);
    return formatted;
  }

  static String dateToStringTime(DateTime date) {
    DateFormat formatter = DateFormat('yyyy年MM月dd日 HH:mm');
    String formatted = formatter.format(date);
    return formatted;
  }

  // 称号を割り当てる処理
  static String getTitle(totalVoteBoutCount, wonBoutCount, wonBoutRate) {
    if (totalVoteBoutCount == 0) {
      return "ひよっこ予想師";
    } else if (totalVoteBoutCount == 1 && wonBoutRate == 100) {
      return "期待のルーキー";
    } else if (totalVoteBoutCount == 1 && wonBoutRate == 0) {
      return "出だし不調な予想師";
    } else if (totalVoteBoutCount == 2 && wonBoutRate == 50) {
      return "これからに期待";
    } else if (totalVoteBoutCount == 2 && wonBoutRate == 0) {
      return "カス予備軍";
    } else if (totalVoteBoutCount == 3 && wonBoutRate == 100) {
      return "神の予感";
    } else if (totalVoteBoutCount == 3 && wonBoutRate > 66) {
      return "優秀な予想師・・・かも？";
    } else if (totalVoteBoutCount == 3 &&
        wonBoutRate > 33 &&
        wonBoutRate < 66) {
      return "平凡な予想師";
    } else if (totalVoteBoutCount == 3 && wonBoutRate == 0) {
      return "カス予想師一歩手前";
    } else if (totalVoteBoutCount == 4 && wonBoutRate == 100) {
      return "神予想師予備軍";
    } else if (totalVoteBoutCount == 4 &&
        wonBoutRate >= 25 &&
        wonBoutRate < 50) {
      return "平凡な予想師";
    } else if (totalVoteBoutCount == 4 &&
        wonBoutRate >= 50 &&
        wonBoutRate < 75) {
      return "そこそこな予想師";
    } else if (totalVoteBoutCount == 4 && wonBoutRate == 0) {
      return "カス予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate == 100) {
      return "神予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 75 &&
        wonBoutRate < 100) {
      return "すごく優秀な予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 50 &&
        wonBoutRate < 75) {
      return "なかなか優秀な予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 25 &&
        wonBoutRate < 50) {
      return "平凡な予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate > 0 && wonBoutRate < 25) {
      return "イマイチな予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate == 0) {
      return "ゴミクズ予想師";
    }
    return "無名の予想師";
  }
}
