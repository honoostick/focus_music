import 'package:provider/provider.dart';
import 'home.dart';
import 'user.dart';

List<ChangeNotifierProvider> providers = [
  ChangeNotifierProvider<HomeModel>(
    create: (_) => HomeModel(0),
  ),
  ChangeNotifierProvider<UserModel>(
    create: (_) => UserModel(),
  )
];
