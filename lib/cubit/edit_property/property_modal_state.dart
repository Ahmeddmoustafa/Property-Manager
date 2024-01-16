// ignore_for_file: must_be_immutable

part of 'property_modal_cubit.dart';

@immutable
class PropertyModalCubitState {
  PropertyModel? property;

  PropertyModalCubitState({required this.property});

  PropertyModalCubitState copyWith({
    required PropertyModel prop,
  }) {
    return PropertyModalCubitState(
      property: prop,
    );
  }
}
