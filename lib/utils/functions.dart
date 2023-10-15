Future<String?> tryCatch(Future Function() callback) async {
  try {
    return await callback();
  } catch (e) {
    return 'An unknown problem occured';
  }
}
