Future<void> delay(bool addDelay, [int milliSeconds = 2000]) {
  if (addDelay) {
    return Future.delayed(const Duration(milliseconds: 2000));
  } else {
    return Future.value();
  }
}
