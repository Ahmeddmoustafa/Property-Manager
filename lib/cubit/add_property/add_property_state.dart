part of 'add_property_cubit.dart';

@immutable
sealed class AddPropertyState {}

class AddPropertyInitial extends AddPropertyState {}

class AddPropertyLoading extends AddPropertyState {}

class PropertyAdded extends AddPropertyState {
  final PropertyModel propertyModel;

  PropertyAdded({required this.propertyModel});
}

class AddPropertyError extends AddPropertyState {}
