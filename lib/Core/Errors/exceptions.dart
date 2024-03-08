class ServerException implements Exception {
  final String msg;

  ServerException({required this.msg});
}

class CacheException implements Exception {}
