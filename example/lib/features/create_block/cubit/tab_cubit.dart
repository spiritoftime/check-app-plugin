import 'package:bloc/bloc.dart';


class TabCubit extends Cubit<int> {
  TabCubit(super.initialState);

   void switchTab(index) => emit(index);
}

