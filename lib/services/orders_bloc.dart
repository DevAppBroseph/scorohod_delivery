import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'objects.dart';

class OrderState {
  OrderState(this.order, this.id);

  OrderState copyWith({
    Order? order,
    int? id,
  }){return OrderState(order ?? this.order, id ?? this.id);}

  Order? order;
  int? id;
}

class OrderBloc extends Cubit<OrderState>{
  OrderBloc() : super(OrderState(null, null));

  void setOrder(Order order) {
    emit(state.copyWith(order: order));
  }

  void setId(int id) {
    emit(state.copyWith(id: id));
  }
}