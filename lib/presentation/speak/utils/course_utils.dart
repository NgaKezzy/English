class UtilsCourse {
  static String convertLevelToString(int level) {
    String levelString = '';
    switch (level) {
      case 1:
        levelString = 'Nhập môn';
        break;
      case 2:
        levelString = 'Sơ cấp';
        break;
      case 3:
        levelString = 'Trung cấp';
        break;
      case 4:
        levelString = 'Cao cấp';
        break;
      default:
        levelString = 'Không có loại cấp độ này';
        break;
    }
    return levelString;
  }
}
