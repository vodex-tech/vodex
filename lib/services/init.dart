bool isInited = false;
init() async {
  if (isInited) return;
  await Future.wait([
    waitFor(const Duration(seconds: 2)),

    /// Add init code here
  ]);
  isInited = true;
}

Future waitFor(Duration duration) async {
  await Future.delayed(duration);
}
