import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/currency_input_formatter.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:get/get.dart';
import 'package:mkplace/widget/btn.dart';
import 'package:mkplace/widget/circular.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';

class ProdutoPerfil extends StatefulWidget {
  @override
  ProdutoPerfilState createState() => ProdutoPerfilState();
}

class ProdutoPerfilState extends State<ProdutoPerfil> with AutomaticKeepAliveClientMixin<ProdutoPerfil> {
  var produto,url='',TB='man_produtos';
  final nome = TextEditingController();
  final descricao = TextEditingController();
  final especificacaoTecnica = TextEditingController();
  final vrVista = TextEditingController();
  final vrParcelado = TextEditingController();
  File? _image;
  bool mostraCircular=false;

  @override
  void initState() {
    Utils.store.remove('imagem');
    Utils.getPermission();
    produto=Get.arguments['dados'] ?? null;
    try {
      Dados.campos.clear();
      Dados.prepara(produto, 'nome',nome, true);
      Dados.prepara(produto, 'descricao',descricao, true);
      Dados.prepara(produto, 'especificacaoTecnica',especificacaoTecnica, false);
      Dados.prepara(produto, 'vrVista',vrVista, false);
      Dados.prepara(produto, 'vrParcelado',vrParcelado, false);
      url=produto['img'];
    } catch (e) {
       print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'produtos'.tr),
        bottomNavigationBar:BottomAppBar(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Botão VISÃO DO CLIENTE
              Padding(
                padding: EdgeInsets.only(top: 3,bottom: 3,left:8,right: 8),
                child: OutlinedButton(
                  style: Utils.OutlinedButtonStlo(mostraCircular,0),
                  child:mostraCircular?Circular():
                  Texto(tit:'produto_preview'.tr,negrito: true,tam: 17,cor:Colors. white,linhas: 2,),

                  onPressed: () {
                    mostraCircular=true;
                    setState(() {});
                    salvar();
                  },
                ),
              ),

              //Botão SALVAR produto
              Padding(
                padding: EdgeInsets.only(top: 3,bottom: 3,left:8,right: 8),
                child: OutlinedButton(
                  style: Utils.OutlinedButtonStlo(mostraCircular,0),
                  child:mostraCircular?Circular():
                  Texto(tit:'salvar'.tr,negrito: true,tam: 17,cor:Colors. white,linhas: 2,),

                  onPressed: () {
                    mostraCircular=true;
                    setState(() {});
                    salvar();
                  },
                ),
              ),
            ],
          ),
        ),
        body:Form(
            key: Utils.formKeyEmpresa,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height : 10.0),
                  MkBoxDecoration(image:_image,url:url,carregaImg: true,),

                  Texto(tit:'dica_foto'.tr),

                  Padding(
                    padding: EdgeInsets.only(top: 30,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'titulo'.tr,hint: 'titulo'.tr,controle: nome,campo: 'nome',),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'descricao'.tr,hint: 'descricao'.tr,controle: descricao,
                      campo:'descricao',linhas: 3,),
                  ),

                  //VALORES **************************
                  Card(
                    color: Colors.white54,
                    child:ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Texto(tit: 'vrs'.tr,tam: 18,negrito:true,cor: Utils.corApp,),
                        ],
                      ),

                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                          child:Edit(label: 'vr_vista'.tr,hint: 'vr_vista'.tr,controle: vrVista,mask:FilteringTextInputFormatter.digitsOnly,
                            mask1: FormatoValorNumerico(maxDigits: 8),input:TextInputType.number,campo: 'vrVista',),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                          child:Edit(label: 'vr_prazo'.tr,hint: 'vr_prazo'.tr,controle: vrParcelado,campo: 'vrParcelado',),
                        ),
                      ],
                    ),
                  ),

                  //ESPECIFICAÇÃO TÉCNICA ************
                  Card(
                    color: Colors.white54,
                  child:ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Texto(tit: 'especifica_tec'.tr,tam: 18,negrito:true,cor: Utils.corApp,),
                      ],
                    ),

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 0,bottom: 0,left:18,right: 2),
                        child:Texto(tit:'especifica_tec_detalhe'.tr,linhas: 2,cor: Colors.grey,),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                        child:Edit(controle: especificacaoTecnica,
                          linhas: 3,campo: 'especificacaoTecnica',),
                      ),
                    ],
                  ),
                  ),

                  //íTENS ADDS ************************
                  Visibility(
                    visible: produto!=null,
                    child:Card(
                      color: Colors.white54,
                      child:ExpansionTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Texto(tit: 'adds'.tr,tam: 18,negrito:true,cor: Utils.corApp,),
                            Btn(tit:'add item',cor: Colors.grey,corTexto:Colors.white, destino: 'produto_add',
                              dados:produto,),
                          ],
                        ),

                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0,bottom: 0,left:18,right: 2),
                            child:Texto(tit:'adds_descri'.tr,linhas: 3,),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                            child:Edit(controle: especificacaoTecnica, linhas: 3,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void salvar() async {
    if (Utils.formKeyEmpresa.currentState!.validate()) {
      mostraCircular=true;
      setState(() {});
      if(produto['idProduto']==null || produto['idProduto']=='') {
        await Dados.inserirDados(TB, context,'');
      }else{
        await Dados.atualizaDados(TB,context,produto['idProduto']);
      }
      if(Utils.store.read('imagem')!=null) {
        url = Utils.store.read('imagem');
        Utils.store.remove('imagem');
      }
      mostraCircular = false;
      setState(() {});
    }
  }

    /*
    para deletar
     var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("users").doc(firebaseUser.uid).delete().then((_) {
    print("success!");
  });

  OU
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("users").doc(firebaseUser.uid).update({
  "username" : FieldValue.delete()
}).then((_) {
  print("success!");
});
     */


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}//276