import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/empresas/emprese_settings.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/texto.dart';

class AdmPedidos extends StatefulWidget {
  @override
  _AdmPedidosState createState() => _AdmPedidosState();
}

class _AdmPedidosState extends State<AdmPedidos> {
  List<String> allStatus = <String>[];
  dynamic dataList;
  TextEditingController editingController = TextEditingController();
  var empresa,nomeEmpresa='aguarde'.tr;

  @override
  void dispose() {
    super.dispose();
  }

  void getdadosEmpresa()async{
    empresa = await Dados.getdadosEmpresa();
    nomeEmpresa=empresa['nome'];
    print(nomeEmpresa);
  }

  Future<dynamic> getPedidos() async {
    dataList = await Dados.databaseReference.collection('man_pedidos').orderBy('dtAtualizado',descending: true).snapshots();
  }

  @override
  void initState() {
    getdadosEmpresa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Texto(tit:'Olá, ' +nomeEmpresa,cor: Colors.white,negrito: true,tam: 18,),
              ),
              IconButton(
                color: Colors.white, icon: new Icon(Icons.settings,),
                onPressed: () {
                  Get.to(() => EmpresaSettings(), arguments: {'dados':empresa,'adm':true});
                },
              )
            ],
          ),
          backgroundColor: Utils.corApp,
        ),
        /*
        body:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Pesquisa",
                    hintText: "Pesquisa",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
            ),
            Expanded(
                child:StreamBuilder(
                  stream: dataList,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return SemRegistro(tit:'Erro inesperado');
                    }

                    if (!snapshot.hasData) {
                      return SemRegistro(tit:'Nenhum fornecedor cadastrado');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SemRegistro(tit:'Aguarde....');
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 5,
                              color: ds["status"] == 'A' ? Colors.white : Colors.grey,
                              child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      //                                  le   to   ri   bo
                                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                                      leading:
                                      Img(tit:ds['img']),
                                      title: Texto(tit:ds["nome"],tam:15.0),
                                      // MENU *******************************
                                      trailing: new Column(
                                        children: <Widget>[
                                          new Container(
                                              child: Utils.menus(ds,context,'man_fornecedor','FornecedorManutencao')
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
          ],
        )

         */
      body:Text('kkkk'),

    );
  }

  Widget menuColaboradores(var idPedido,BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          switch(value) {
            case 1://STATUS
              status(context,idPedido);
              break;
            case 2: // EXCLUIR
              Dados.del(idPedido,'man_pedidos',context,'');
              break;
            case 3: // EXCLUIR
              trocarVendedor(idPedido);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.autorenew),
                  ),
                  Text('Status')
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.auto_fix_normal),
                  ),
                  Text('Excluir')
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.autorenew),
                  ),
                  Text('Trocar vendedor')
                ],
              )),

        ]);
  }

  trocarVendedor(String idPedido)async{
    //final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => AdmConsultaVendedor()));
    //if(nmServ!=null && nmServ!=''){
      //var comVr = nmServ.toString().split('#');
     // await Dados.databaseReference.collection('man_pedidos').doc(idPedido).update({'nmVendedor': comVr[1],'idVendedor':comVr[0]});
   // }
  }

  status(BuildContext context,idPedido) async{
    //final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => StatusPesquisa()));
    //if (nmServ != null) {
      //var vSplit = nmServ.split('#');
     // await Dados.databaseReference.collection('man_pedidos').doc(idPedido).update({
       // 'status': vSplit[0],'idStatus':vSplit[1]});
   // }
  }
}