import 'package:flutter_spacex/data_model.dart';

enum LoadingState { loading, error, content }

class PayloadViewModel {
  List<Payload>? payload;
  LoadingState state;

  PayloadViewModel(this.payload, this.state);
}
