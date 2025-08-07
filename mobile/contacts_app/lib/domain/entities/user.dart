import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateCreated;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateCreated,
  });

  @override
  List<Object> get props => [id, email, firstName, lastName, dateCreated];

}