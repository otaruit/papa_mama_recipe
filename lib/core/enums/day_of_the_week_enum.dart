enum DayOfTheWeekType {
  monday('月'),
  tuesday('火'),
  wednesday('水'),
  thursday('木'),
  friday('金'),
  saturday('土'),
  sunday('日'),
  
  ;

  final String dayOfTheWeekNum;
  const DayOfTheWeekType(this.dayOfTheWeekNum);
}

extension ConvertDayOfTheWeek on int {
  DayOfTheWeekType toDayOfTheWeekTypeEnum() {
    switch (this) {
       case 0:
        return DayOfTheWeekType.monday;
      case 1:
        return DayOfTheWeekType.tuesday;
      case 2:
        return DayOfTheWeekType.wednesday;
      case 3:
        return DayOfTheWeekType.thursday;
      case 4:
        return DayOfTheWeekType.friday;
      case 5:
        return DayOfTheWeekType.saturday;
      case 6:
        return DayOfTheWeekType.sunday;
      default:
        throw Exception('Invalid day of the week number');
    }
  }
}
