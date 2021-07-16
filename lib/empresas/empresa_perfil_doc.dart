import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';

import 'empresa_perfil_senha.dart';

class EmpresaPerfilDoc extends StatefulWidget {

  @override
  _EmpresaPerfilDocState createState() => _EmpresaPerfilDocState();
}

class _EmpresaPerfilDocState extends State<EmpresaPerfilDoc> with Utils,AutomaticKeepAliveClientMixin<EmpresaPerfilDoc> {
  final cnpj = TextEditingController();
  final cpf = TextEditingController();
  final tabela='man_empresa';
  File? _image;
  final picker = ImagePicker();
  String msg='avancar'.tr;
  Color cor=Utils.corApp;
  var dados;

  String url='https://firebasestorage.googleapis.com/v0/b/mkjobs-38a22.appspot.com/o/DOC%2F0K7LJ1v76NKKDRZZWUVQ.jpeg?alt=media&token=422c0669-9d59-4554-b06c-824930d926b0';

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
                    padding: EdgeInsets.only(top: 30,bottom: 20,left:2,right: 2),
                    child:Edit(label: 'CNPJ',hint: 'CNPJ',controle: cnpj,mask: FilteringTextInputFormatter.digitsOnly,
                      mask1: CnpjInputFormatter(),input:TextInputType.number ,),
                  ),
                  Texto(tit:'Ou',negrito: true,tam: 18,),
                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'CPF',hint: 'CPF',controle: cpf,mask: FilteringTextInputFormatter.digitsOnly,
                      mask1: CpfInputFormatter(),input:TextInputType.number ,),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void salvar() async{
    if(cpf.text!='' && cnpj.text!=''){
      Utils.snak('atencao'.tr,'escolha_doc'.tr,true,Colors.red);
      return;
    }
      String doc='';
      bool valida=false;
      if(cnpj.text==''){
        doc=cpf.text;
        valida=UtilBrasilFields.isCPFValido(doc);
      }else{
        doc=cnpj.text;
        valida=UtilBrasilFields.isCNPJValido(doc);
      }
      if(!valida) {
        Utils.snak('atencao'.tr,'doc_invalido'.tr,true,Colors.red);
        return;
      }

      if (dados != null) {
        //ATUALIZANDO
        await Dados.databaseReference.collection(tabela).doc(
            dados.id).update({'doc': doc, 'dtAlterado': FieldValue.serverTimestamp()});
      } else {
        //INCLUINDO
        //Verifica se o CPF/CNPJ já está cadastrado
        var empresa = await Dados.getData(tabela, 'doc', doc, 'nome');

        if (empresa != null) {
          //Doc já foi utilizado
          Utils.snak('doc_usado'.tr, 'doc_opcao'.tr, true,Colors.red);
        }else{
          //volta e apaga todo o histórico de navegacao
          //Get.offAll(Autentica());
          //Nova empresa
          await Dados.databaseReference.collection(tabela).add({
            'doc': doc,
            'status': 'A',
            'img': '',
            'nome': '',
            'dtCriado': FieldValue.serverTimestamp(),
            'dtAlterado': FieldValue.serverTimestamp()
          });
          var empresa = await Dados.getData(tabela, 'doc', doc, 'nome');
          Get.to(() => EmpreseSenha(), arguments: {'dados':empresa});
        }
      }
  }

  @override
  bool get wantKeepAlive => true;
}//136