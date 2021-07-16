import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'adm/adm_pedidos.dart';
import 'empresas/empresa_perfil.dart';
import 'inicio/autentica.dart';
import 'inicio/bem_vindo.dart';
import 'lang/translation_service.dart';
import 'produtos/produto_perfil.dart';
import 'produtos/produtos_add.dart';
import 'produtos/produtos_itens.dart';
import 'produtos/produtos_lista.dart';
import 'tabelas/perfil_padrao.dart';
import 'tabelas/tabelas.dart';

void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final datacount = GetStorage();
  static final tpUser=datacount.read('tipoUser');

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mk Place',
      routes: {
        'bem_vindo': (context) => BemVindo(),
        'autentica': (context) => Autentica(),
        'empresa_perfil': (context) => EmpresaPerfil(),
        'tabelas': (context) => Tabelas(),
        'perfil_padrao': (context) => PerfilPadrao(),
        'produto_lista': (context) => ProdutosLista(),
        'produto_perfil': (context) => ProdutoPerfil(),
        'produto_add': (context) => ProdutosAdd(),
        'produto_itens': (context) => ProdutosItens(),
      },
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: tpUser==null?BemVindo():tpUser=='ADM'? AdmPedidos():BemVindo(),
    );
  }
}