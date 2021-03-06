import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/sem_registro.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';

class ListaPadrao extends StatefulWidget {
  @override
  _ListaPadraoState createState() => _ListaPadraoState();
}

class _ListaPadraoState extends State<ListaPadrao> with AutomaticKeepAliveClientMixin<ListaPadrao> {
  Stream? dataList;
  var tit,TB,destino;

  @override
  void initState() {
    tit =Get.arguments['tit'] ?? null;
    TB =Get.arguments['TB'] ?? null;
    destino =Get.arguments['destino'] ?? null;

    dataList = Dados.databaseReference.collection(TB).orderBy('nome').snapshots();
    print(dataList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BarraStatus(tit:tit),
      body: Column(
        children: <Widget>[
          Expanded(
            child:dataList==null?SemRegistro(tit:tit+' sem_dados'.tr):

            StreamBuilder(
              stream: dataList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return SemRegistro(tit:'erro_inesperado'.tr);
                }

                if (!snapshot.hasData) {
                  return SemRegistro(tit:tit+' sem_dados'.tr);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SemRegistro(tit:'aguarde'.tr);
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return Padding(
                        padding:EdgeInsets.fromLTRB(0.0, 5.0, 1.0, 5.0) ,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6,
                          color: ds["status"] == 'A' ? Colors.white : Colors.grey,
                          child: Column(
                              children: <Widget>[
                                ListTile(
                                  dense:true,
                                  //                                  le   to   ri   bo
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 1.0, 5.0),
                                  title: Texto(tit:ds["nome"],tam:15.0),
                                  // MENU *******************************
                                  trailing: new Column(
                                    children: <Widget>[
                                      new Container(
                                          child: Utils.menus(ds,context,TB,destino,tit,'')
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
          Utils.execute(context,tit,TB,'perfil_padrao',''),
        ],
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}