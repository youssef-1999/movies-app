
class Failure {
  final String message;
  Failure(this.message);
}
  class AuthFailure extends Failure {
    // Handle authentication failure
    AuthFailure(super.message);}