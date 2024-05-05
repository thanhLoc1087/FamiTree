
String removeVietnameseTones(String str) {
  str = str.replaceAll(RegExp(r"à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ"), "a");
  str = str.replaceAll(RegExp(r"è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ"), "e");
  str = str.replaceAll(RegExp(r"ì|í|ị|ỉ|ĩ|ĩ/g"), "i");
  str = str.replaceAll(RegExp(r"ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ"), "u");
  str = str.replaceAll(RegExp(r"ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ"), "o");
  str = str.replaceAll(RegExp(r"ỳ|ý|ỵ|ỷ|ỹ|ỹ"), "y");
  str = str.replaceAll(RegExp(r"đ|đ"), "d");

  return str;
}