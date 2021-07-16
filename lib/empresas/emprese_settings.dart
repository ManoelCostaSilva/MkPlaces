import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:get/get.dart';

import 'empresa_settings_itens.dart';

class EmpresaSettings extends StatefulWidget {
  @override
  EmpresaSettingsState createState() => EmpresaSettingsState();
}

class EmpresaSettingsState extends State<EmpresaSettings> with AutomaticKeepAliveClientMixin<EmpresaSettings> {
  var empresa;
  static final datacount = GetStorage();


  @override
  void initState() {
    empresa=Get.arguments['dados'] ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:empresa['nome']),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BtnLista(tit:'Perfil',destino: 'empresa_perfil',tam: 18,ID: '1',icon:Icons.contact_phone_rounded,
                      iconCor: Colors.red,dados: empresa,),
                  ),
                  Expanded(
                    child:BtnLista(tit:'Consulta',destino: 'TIPO_RESIDENCIA',tam: 18,icon:Icons.add_chart,iconCor: Colors.blue,),
                  ),
                  Expanded(
                    child:BtnLista(tit:'Clientes',destino: 'TIPO_RESIDENCIA',tam: 18,icon:Icons.perm_contact_cal_outlined,iconCor: Colors.green,),
                  ),
                ],
              ),
              //*****************************************************************
              SizedBox(height : 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:BtnLista(tit:'Usuários',destino: 'TIPO_RESIDENCIA',tam: 18,icon:Icons.supervised_user_circle_sharp,iconCor: Colors.green,),
                  ),
                  Expanded(
                    child:BtnLista(tit:'Tabelas',destino: 'tabelas',tam: 18,icon:Icons.add_business_sharp,iconCor: Colors.green,),
                  ),
                  Expanded(
                    child:BtnLista(tit:'Produtos',destino: 'produto_lista',tam: 18,icon:Icons.add_chart,iconCor: Colors.green,),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}