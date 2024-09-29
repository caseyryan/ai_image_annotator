import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

Random _random = Random();

List<String> _zipCodes = [
  '94042',
  '94039',
  '94035',
  '95036',
  '95155',
  '95154',
  '95159',
  '95173',
  '95056',
  '94309',
  '94302',
  '94543',
  '95009',
  '94088',
  '95164',
  '95172',
  '95052',
  '95157',
  '95141',
  '95055',
];

int randomRange(int min, int max) {
  return min + _random.nextInt((max + 1) - min);
}

Key getRandomKey() {
  return Key(_random.nextDouble().toString());
}

String generateRandomZipCode() {
  return _getRandomFromList(_zipCodes);
}

String randomSex() {
  var isMale = _random.nextBool();
  return isMale ? 'MALE' : 'FEMALE';
}

List<String> _addressParts = [
  'California',
  'Palo Alto',
  'Los Angeles',
  'Mokito',
  'Sacramento',
  'San Francisco',
];

String generateRandomAddress() {
  var street = _getRandomFromList(_addressParts);
  var city = _getRandomFromList(_addressParts);
  var home = randomRange(1, 10000);
  return 'USA, $city, $street $home';
}

String generateRandomCity() {
  return _getRandomFromList(_addressParts.sublist(0));
}

List<String> _firstNames = [
  'John',
  'Clarissa',
  'Silvia',
  'Marina',
  'Vasya',
  'Dmitro',
  'Alex',
  'Lucy',
  'Ivan',
  'Daniel',
  'Mike',
  'Denis',
  'Konstantin',
  'Andrew',
  'Sanya',
  'Maria',
  'Karolina',
  'Victor',
  'Natalie',
  'Leon',
  'Matilda',
  'Arnold',
  'Vadym',
  'Paul',
  'Thomas',
  'Orlando',
  'Anatoly',
  'Oleg',
  'Ashlee',
  'Steve',
  'Donald',
];
List<String> _lastNames = [
  'Tinkoff',
  'Nilson',
  'Schwarzenegger',
  'Morrison',
  'Harrison',
  'Simpson',
  'Trump',
  'Biden',
  'Stepanoff',
  'Clinton',
  'Jefferson',
  'Willis',
  'Sarkazi',
  'King',
  'Bradley',
  'Bethoven',
];

List<String> _addresses = [
  'Las',
  'San',
  'Hose',
  'Vegas',
  'Angeles',
  'Los',
  'New',
  'York',
];

String getRandomAddress() {
  return '${_getRandomFromList(_addresses)} ${_getRandomFromList(_addresses)} ${randomInt(10000, 999999)}';
}

String _getRandomFromList(List<String> strings) {
  return strings[_random.nextInt(strings.length)];
}

String generateRandomFirstName() {
  return _getRandomFromList(_firstNames);
}

String generateRandomEmail() {
  return '${generateRandomFirstName()}.${generateRandomLastName()}${randomInt(10000, 999999)}@yandex.ru'
      .toLowerCase();
}

String generateRandomPhone() {
  return formatAsPhoneNumber(
          '${randomRange(100000000, 199999999).toString()}00') ??
      '';
}

Key generateRandomKey() {
  return ValueKey(_random.nextDouble());
}

int randomInt(int min, int max) {
  return _random.nextInt(max + 1 - min) + min;
}

DateTime randomDate([int startYear = 1950, int endYear = 2002]) {
  var randomYear = randomInt(startYear, endYear);
  var randomMonth = randomInt(1, 12);
  var randomDay = randomInt(1, 28);
  return DateTime(randomYear, randomMonth, randomDay);
}

String generateRandomLastName([bool twoPart = true]) {
  var part1 = _getRandomFromList(_lastNames);
  if (twoPart) {
    var part2 = _getRandomFromList(_lastNames);
    return '$part1-$part2';
  }
  return part1;
}
