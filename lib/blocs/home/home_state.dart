import 'package:dripzy/models/product_model.dart';

abstract class HomeState {
  final String message;
  HomeState({this.message = ""});
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> products;
  HomeLoaded({required this.products});
}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}