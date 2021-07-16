import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class EmpresaLogin extends StatefulWidget {

  @override
  _EmpresaLoginState createState() => _EmpresaLoginState();
}

class _EmpresaLoginState extends State<EmpresaLogin> with Utils,AutomaticKeepAliveClientMixin<EmpresaLogin> {
  final cnpj = TextEditingController();
  final cpf = TextEditingController();
  final senha = TextEditingController();
  final tabela='man_empresa';
  File? _image;
  final picker = ImagePicker();
  String msg='avancar'.tr;
  Color cor=Utils.corApp;
  var dados;
  static final datacount = GetStorage();

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

                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'senha'.tr,hint: 'senha'.tr,controle: senha,),
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
    String? doc=Utils.validaDoc(cpf.text,cnpj.text);

    if(doc=='') {
      Utils.snak('atencao'.tr,'doc_invalido'.tr,true,Colors.red);
      return;
    }

    var empresa = await Dados.getData(tabela, 'doc', doc!, 'nome');

    if (empresa == null) {
      //Empresa não cadastrada
      Utils.snak('atencao'.tr, 'doc_senha_invalido'.tr,true,Colors.red);
      return;
    }
    //Empresa cadastrada e com DOC válido.Verifica se a senha confere
    try{
      empresa['senha'];
      //Tem o campo senha, verifica se a senha está correta
      if(empresa['senha']==senha.text){
        //senha correta
        datacount.write('tipoUser','ADM');
        datacount.write('idUser',empresa.id);
        datacount.write('idDoc',empresa['doc']);
        Get.to(() => AdmPedidos(), arguments: {'dados':empresa,'adm':true});
      }else{
        //senha inválida
        Utils.snak('atencao'.tr, 'doc_senha_invalido'.tr,true,Colors.red);
        return;
      }
    } catch (e) {
      //Ainda não cadastrou a senha
     // Get.to(() => EmpreseSenha(), arguments: {'dados':empresa});
    };
  }
  @override
  bool get wantKeepAlive => true;
}//136