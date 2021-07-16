import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkplace/adm/adm_pedidos.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';

class EmpreseSenha extends StatefulWidget {

  @override
  _EmpreseSenhaState createState() => _EmpreseSenhaState();
}

class _EmpreseSenhaState extends State<EmpreseSenha> with Utils,AutomaticKeepAliveClientMixin<EmpreseSenha> {
  final senha1 = TextEditingController();
  final senha2 = TextEditingController();
  final tabela='man_empresa';
  File? _image;
  final picker = ImagePicker();
  String msg='avancar'.tr;
  Color cor=Utils.corApp;
  var dados;
  static final datacount = GetStorage();
  String url='https://firebasestorage.googleapis.com/v0/b/mkjobs-38a22.appspot.com/o/DOC%2F9uhJgPxW4PT6Wi2pAAZb.jpeg?alt=media&token=825ed8cc-aac6-4254-8b1c-21f21ecf9ca6';

  @override
  void initState() {
    dados=Get.arguments['dados'] ?? null;
    super.initState();
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
                  backgroundColor: cor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Texto(tit:msg,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                salvar();
              },
            ),
          ),
        ),

        body:Center(
          child:Form(
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //imagem
                  MkBoxDecoration(image:_image,url:url,carregaImg: false,),

                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 0,left:8,right: 2),
                    child:Texto(tit:'senha_nao_cadastrada'.tr,negrito: true,tam: 18,)
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 0,bottom: 0,left:8,right: 2),
                      child:Texto(tit:'senha_informe'.tr,negrito: true,tam: 18,)
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 30,bottom: 20,left:2,right: 2),
                    child:Edit(label: 'senha'.tr,hint: 'senha'.tr,controle: senha1,),
                  ),
                  Texto(tit: 'senha_repita'.tr,negrito: true,tam: 18,),
                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'senha'.tr,hint: 'senha'.tr,controle: senha2,),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void salvar() async{
    if(senha1.text != senha2.text || senha1.text=='' || senha2.text==''){
      Utils.snak('atencao'.tr,'senha_dife'.tr,true,Colors.red);
      return;
    }
    datacount.write('tipoUser','ADM');
    datacount.write('idUser',dados.id);
    datacount.write('idDoc',dados['doc']);
    await Dados.atualizaSenha(tabela, senha1.text, dados.id);
    Get.to(() => AdmPedidos(), arguments: {'dados':dados,'adm':true});
  }

  @override
  bool get wantKeepAlive => true;
}//136