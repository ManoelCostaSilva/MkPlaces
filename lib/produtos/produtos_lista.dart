import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/img.dart';
import 'package:mkplace/widget/sem_registro.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';

class ProdutosLista extends StatefulWidget {
  @override
  _ProdutosListaState createState() => _ProdutosListaState();
}

class _ProdutosListaState extends State<ProdutosLista> with AutomaticKeepAliveClientMixin<ProdutosLista> {
  Stream? dataList;
  var tit,TB,destino;
  String url='';

  @override
  void initState() {
    url='https://firebasestorage.googleapis.com/v0/b/mkjobs-38a22.appspot.com/o/DOC%2FdlVcbaygRTkrjUWRCLVk.jpeg?alt=media&token=5726cea4-f39e-4c80-9d18-e3c4e564d9f5';
    tit ='produtos'.tr;
    TB= 'man_produtos';
    destino='produto_perfil';
    dataList = Dados.databaseReference.collection(TB).orderBy('nome').snapshots();
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
                                  //                                  le   to   ri   bo
                                  contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                  leading: Img(tit:ds['img']==''?url:ds['img'],tam: 50,),
                                  title: Transform.translate(offset: Offset(-25, 0),
                                    child: Texto(tit:ds["nome"],tam:15.0),
                                  ),

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
          Utils.execute(context,tit,TB,'produto_perfil',''),
        ],
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}