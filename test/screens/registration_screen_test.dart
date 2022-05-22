import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap_shop/main.dart';
import 'package:swap_shop/screens/login_screen.dart';
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

  //Widget createLoginScreen() => Ch

 group('Counter', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}
