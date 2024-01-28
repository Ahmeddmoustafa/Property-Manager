// ignore_for_file: must_be_immutable

part of 'property_modal_cubit.dart';

@immutable
class PropertyModalState {
  PropertyModel? property;

  PropertyModalState({required this.property});

  PropertyModalState copyWith({
    required PropertyModel prop,
  }) {
    return PropertyModalState(
      property: prop,
    );
  }
}
