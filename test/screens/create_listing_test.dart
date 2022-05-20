import 'package:flutter_test/flutter_test.dart';
import 'package:swap_shop/screens/create_listing.dart';

void main() {
  test('Empty item name field', () async{
    var result = ItemNameValidator.validate('');
    expect(result, "Item Name Cannot be Empty" );
  });
  test('Date empty', () async{
    var result = dateFieldValidator.validate('');
    expect(result, 'Date is not selected');
  });
test("Empty description box", () async{
  var result = descriptionFieldValidator.validate('');
  expect(result, "Description Cannot be Empty");
});

test('empty clothe size', () async{
  var result = clotheSizeFieldValidator.validate(null);
  expect(result, '      Please select category.');
});
}
