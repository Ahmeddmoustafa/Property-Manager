part of 'property_cubit.dart';

@immutable
class PropertyState {
  final List<PropertyModel> properties;

  PropertyState({required this.properties});

  PropertyState copyWith({
    required List<PropertyModel> list,
  }) {
    return PropertyState(
      properties: list,
    );
  }
}

// class PropertyInitial extends PropertyState {}

// class PropertyLoading extends PropertyState {}

// class PropertyFailed extends PropertyState {}

// class PropertyLoaded extends PropertyState {
//   final List<PropertyModel> properties;

//   PropertyLoaded({required this.properties});

//   PropertyLoaded copyWith(List<PropertyModel> list) {
//     return PropertyLoaded(properties: list);
//   }
// }
