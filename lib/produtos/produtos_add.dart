import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/circular.dart';
import 'package:mkplace/widget/sem_registro.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';

class ProdutosAdd extends StatefulWidget {
  @override
  _ProdutosAddState createState() => _ProdutosAddState();
}

class _ProdutosAddState extends State<ProdutosAdd> with AutomaticKeepAliveClientMixin<ProdutosAdd> {
  Stream? dataList,lista;
  var TB,dados,produtoEscolhido;
  bool mostraCircular=false;

  @override
  void initState() {
    TB= 'man_produtos_add';
    dados =Get.arguments['dados'] ?? null;
    dataList = Dados.databaseReference.collection(TB).where('idProduto', isEqualTo: dados.id).orderBy('nome').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: BarraStatus(tit:dados['nome']),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 3,bottom: 3,left:8,right: 8),
            child: OutlinedButton(
              style: Utils.OutlinedButtonStlo(mostraCircular,0),
              child:mostraCircular?Circular():
              Texto(tit:'new_item'.tr,negrito: true,tam: 17,cor:Colors. white,linhas: 2,),

              onPressed: () {
                Dados.setIdProduto(dados.id);
                Get.toNamed('perfil_padrao',arguments: {'dados':null,'TB':TB,'tit':dados['nome'],});;
              },
            ),
          ),
        ),
      body: Column(
        children: <Widget>[
          Expanded(
            child:dataList==null?SemRegistro(tit:dados['nome']+' sem_dados'.tr):

            StreamBuilder(
              stream: dataList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return SemRegistro(tit:'erro_inesperado'.tr);
                }

                if (!snapshot.hasData) {
                  return SemRegistro(tit:dados['nome']+' sem_dados'.tr);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SemRegistro(tit:'aguarde'.tr);
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      detalhe(ds.id);
                      return Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6,
                          color: ds["status"] == 'A' ? Colors.white : Colors.grey,
                          child: Column(
                              children: <Widget>[
                                ExpansionTile(
                                  onExpansionChanged: (value) {
                                    setState(() {
                                      produtoEscolhido=ds;
                                    });
                                  },
                                  title:ListTile(
                                    dense:true,
                                    title: Texto(tit: ds["nome"],tam: 18,negrito:true,cor: Utils.corApp,),
                                  ),

                                  children: <Widget>[
                                    Card(
                                      color: Colors.purpleAccent,
                                      elevation: 6,
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 3,bottom: 3,left:10,right: 0),
                                            child:OutlinedButton(
                                              style: Utils.OutlinedButtonStlo(mostraCircular,0),
                                              child:mostraCircular?Circular():
                                              Texto(tit:'new'.tr,negrito: true,tam: 14,cor:Colors. white,linhas: 2,),
                                              onPressed: () {
                                                Get.toNamed('produto_itens',arguments: {'dados':produtoEscolhido,'TB':TB,});
                                              },
                                            ),
                                          ),

                                          new Container(
                                              child: Utils.menus(produtoEscolhido,context,TB,'perfil_padrao',dados['nome'],'')
                                          )
                                        ]
                                    ),
                                    ),

                                    //SUB-ITENS********************************************************
                                    StreamBuilder(
                                      stream: lista,
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                                        if (!snapshot.hasData) {
                                          return SemRegistro(tit:' ');
                                        }

                                        if(snapshot!=null) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot det = snapshot.data.docs[index];
                                                var padrao='';
                                                if(det['padrao']=='true'){
                                                 padrao=' Padrão';
                                                }
                                                return Card(
                                                  //color: Colors.white54,
                                                  color: det["status"] == 'A' ? Colors.white : Colors.grey,
                                                  elevation: 6,
                                                  child:ListTile(
                                                    //                                  le   to   ri   bo
                                                    contentPadding: EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
                                                    title: Column(
                                                        children: <Widget>[
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 0),
                                                                  child: Texto(tit: det['descri']+' ('+padrao+')'),
                                                                ),
                                                              ]
                                                          ),

                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child:Padding(
                                                                padding: EdgeInsets.only(top: 3,bottom: 3,left:5,right: 0),
                                                                child:Texto(tit:det['valor'],negrito: true,tam: 18,)
                                                            ),
                                                          ),
                                                        ]
                                                    ),

                                                    // MENU *******************************
                                                      trailing: new Column(
                                                        children: <Widget>[
                                                          new Container(
                                                              child: Utils.menus(det,context,TB,'produto_itens','kkkk',produtoEscolhido.id)
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                              });
                                        }else{
                                          return Container();
                                        }
                                        },
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        );
                    });
              },
            ),
          ),
        ],
      )
    );
  }

  detalhe(String id)async{
    lista = await Dados.databaseReference.collection(TB).doc(id).collection('itens').snapshots();
  }

  @override
  bool get wantKeepAlive => true;
}//224