class VariableTransFormation {
  static String getDayOfTheWeek(int dayOfTheWeek) {
    switch (dayOfTheWeek) {
      case 0:
        return '月';
      case 1:
        return '火';
      case 2:
        return '水';
      case 3:
        return '木';
      case 4:
        return '金';
      case 5:
        return '土';
      case 6:
        return '日';
      default:
        throw Exception('Invalid day of the week number');
    }
  }

  static String getRecipeType(int recipeType) {
    switch (recipeType) {
      case 0:
        return 'メイン';
      case 1:
        return 'サイド';
      case 2:
        return 'スープ';
      case 3:
        return 'その他';
      default:
        throw Exception('Invalid day of the week number');
    }
  }
}
