enum AuthStatus {
  loggedin,
  loggedout,
}

enum LoadingStatus {
  loading,
  idle,
  error,
}

class Response<T> {
  LoadingStatus status;
  String message;
  T data;

  Response({
    required this.message,
    required this.status,
    required this.data,
  });
}
