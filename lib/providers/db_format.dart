//DB VARIABLES

// DB Variables
// id,
// text -> value  공통으로 가지는 값이니까
// groupkey -> sort 이제 종류를 구분해야하니까
// groupvalue -> motherID 하위일 경우 상위 DB Variables로 한정

class DbFormats {
  static String table = 'Shelf';

  static String note = 'note';
  static String noteChild = 'noteChild';

  static String todo = 'todo';

  static String recipe = 'recipe';
  static String recipeChildStuff = 'recipeChildStuff';
  static String recipeChildProcess = 'recipeChildProcess';

  static String book = 'book';
  static String id = 'id';
  static String value = 'value';
  static String subValue = 'subValue';
  static String date = 'date';
  static String sort = 'sort';
  static String motherId = 'motherId';
}
