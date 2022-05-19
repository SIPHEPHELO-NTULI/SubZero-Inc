import 'package:flutter_test/flutter_test.dart';
import 'package:swap_shop/screens/registration_screen.dart';


void main() {
  test('name empty', () async {
    var result = nameFieldValidator.validate('');
    expect(result, "Name Cannot be Empty");
  });
  test('name has less than three characters', () async {
    var result = nameFieldValidator.validate('ab');
    expect(result, "Please Enter Valid Name (3 Characters Min)");
  });
  test('surname field is empty', () async{
    var result = surnameFieldValidator.validate(''); 
    expect(result, "Surname Cannot be Empty");
  });
  test("surname has less then 3 characters", () async{
    var result = surnameFieldValidator.validate('1w');
    expect(result, "Please Enter Valid Surname (3 Characters Min)");
  });
  test("username field empty", () async{
    var result = userNameFieldValidator.validate('');
    expect(result, "Username Cannot be Empty");
  });
  test("username has less then 3 characters", () async{
    var result = userNameFieldValidator.validate('we');
    expect(result, "Please Enter Valid Username (3 Characters Min)");
  });

  test("Empty confirm password field", () async{
    var result = confirmPasswordValidator.validate('');
    expect(result,"Passwords don't match");
  });
  
}
