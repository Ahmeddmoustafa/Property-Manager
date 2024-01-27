part of 'add_property_cubit.dart';

// @immutable
class AddPropertyState {
  final bool error;

  AddPropertyState({required this.error});
  AddPropertyState copyWith({
    required bool err,
  }) {
    return AddPropertyState(
      error: err,
    );
  }
}

// class AddPropertyInitial extends AddPropertyState {}

// class AddPropertyLoading extends AddPropertyState {}

// class PropertyAdded extends AddPropertyState {
//   final PropertyModel propertyModel;

//   PropertyAdded({required this.propertyModel});
// }

// class AddPropertyError extends AddPropertyState {}
