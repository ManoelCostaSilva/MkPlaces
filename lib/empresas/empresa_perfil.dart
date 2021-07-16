import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:get/get.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';

class EmpresaPerfil extends StatefulWidget {
  @override
  EmpresaPerfilState createState() => EmpresaPerfilState();
}

class EmpresaPerfilState extends State<EmpresaPerfil> with AutomaticKeepAliveClientMixin<EmpresaPerfil> {
  var empresa,url='';
  final nome = TextEditingController();
  final cidade = TextEditingController();
  final uf = TextEditingController();
  File? _image;


  @override
  void initState() {
    Utils.store.remove('imagem');
    Utils.getPermission();
    empresa=Get.arguments['dados'] ?? null;
    try {
      url=empresa['img'];
      nome.text=empresa['nome'];
      cidade.text = empresa['cidade'];
      uf.text = empresa['uf'];
    } catch (e) {
       print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'minha_empresa'.tr),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Utils.corApp,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Texto(tit:'salvar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                salvar();
              },
            ),
          ),
        ),
        body:Form(
            key: Utils.formKeyEmpresa,
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height : 20.0),
                  MkBoxDecoration(image:_image,url:url,carregaImg: true,),

                  Texto(tit:'dica_foto'.tr),

                  Texto(tit:empresa['doc'],negrito: true,tam: 18,),

                  Padding(
                    padding: EdgeInsets.only(top: 30,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'fantasia'.tr,hint: 'fantasia'.tr,controle: nome,),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'cidade'.tr,hint: 'cidade'.tr,controle: cidade,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'uf'.tr,hint: 'uf'.tr,controle: uf,),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void salvar() async {
    if (!Utils.formKeyEmpresa.currentState!.validate()) {
      Utils.snak('atencao'.tr, 'verifique_campos'.tr,true,Colors.red);
      return;
    }

    await Dados.databaseReference.collection('man_empresa').doc(
          empresa.id).update(
          {'nome': nome.text, 'cidade': cidade.text, 'uf': uf.text,
            'dtAlterado': FieldValue.serverTimestamp()});

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');
      await Utils.uploadFile(empresa.id, img, 'man_empresa', context,'DOC','.jpeg');
    }
    Utils.snak('parabens'.tr,'sucesso'.tr,true,Colors.green);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}