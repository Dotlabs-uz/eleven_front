import '../../presensation/widget/my_icon_button.dart';

class TopMenuEntity {
  final dynamic searchCubit;
  final List<IconButtonImpl> iconList;
  final bool enableSearch ;

  TopMenuEntity({this.enableSearch= true, required this.searchCubit, required this.iconList});

  factory TopMenuEntity.empty() {
    return TopMenuEntity(searchCubit: null, iconList: [], enableSearch: true);
  }
}
