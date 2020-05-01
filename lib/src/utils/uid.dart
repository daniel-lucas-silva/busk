import 'dart:math';

String generateID() {
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int counter = _nextCounter();

  List<String> charCodes = List<String>(24);
  int i = 0;
  for (final b in _b(timestamp, _generatedMachineId, _generatedProcessId, counter)) {
    charCodes[i++] = _hexChars[b >> 4 & 0xF];
    charCodes[i++] = _hexChars[b & 0xF];
  }
  return charCodes.join('');
}

//  int _timestamp,int _machineId, int _processId, int _counter

List<int> _b(int _timestamp,int _machineId, int _processId, int _counter) {
  List<int> bytes = List<int>(12);
  bytes[0] = _int3(_timestamp);
  bytes[1] = _int2(_timestamp);
  bytes[2] = _int1(_timestamp);
  bytes[3] = _int0(_timestamp);
  bytes[4] = _int2(_machineId);
  bytes[5] = _int1(_machineId);
  bytes[6] = _int0(_machineId);
  bytes[7] = _int1(_processId);
  bytes[8] = _int0(_processId);
  bytes[9] = _int2(_counter);
  bytes[10] = _int1(_counter);
  bytes[11] = _int0(_counter);
  return bytes;
}


const _lowerOrderTwoBytes = 0x0000FFFF;
const _lowerOrderThreeBytes = 0x00FFFFFF;

int _globalCounter = Random.secure().nextInt(_lowerOrderThreeBytes);

int _nextCounter() {
  _globalCounter = (_globalCounter + 1) & _lowerOrderThreeBytes;
  return _globalCounter;
}

int _createMachineId() {
  // FIXME: Build a 3-byte machine piece based on NICs info and
  // fallback to random number only if NICs info is not available.
  return Random.secure().nextInt(_lowerOrderThreeBytes);
}

int _createProcessId() {
  // FIXME: Get the real process Id instead of creating a random number.
  return Random.secure().nextInt(_lowerOrderTwoBytes);
}

int _generatedMachineId = _createMachineId();

int _generatedProcessId = _createProcessId();

int _makeInt(int b3, int b2, int b1, int b0) => (b3 << 24) | (b2 << 16) | (b1 << 8) | b0;

int _int3(int x) => (x & 0xFF000000) >> 24;
int _int2(int x) => (x & 0x00FF0000) >> 16;
int _int1(int x) => (x & 0x0000FF00) >> 8;
int _int0(int x) => (x & 0x000000FF);

List<String> _hexChars = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f'
];
