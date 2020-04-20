import 'package:provider/provider.dart';
import 'home.dart';

List<ChangeNotifierProvider> providers = [
  ChangeNotifierProvider<HomeModel>(
    create: (_) => HomeModel(0),
  )
];
