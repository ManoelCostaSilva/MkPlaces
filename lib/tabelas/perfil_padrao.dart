import 'package:flutter/material.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/circular.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';

class PerfilPadrao extends StatefulWidget {

  @override
  _PerfilPadraoState createState() => _PerfilPadraoState();
}

class _PerfilPadraoState extends State<PerfilPadrao> with AutomaticKeepAliveClientMixin<PerfilPadrao> {
  final nome = TextEditingController();

  var tit,ID,TB,dados;
  bool mostraCircular=false,escolhido=false;
  Color corSelecionado=Colors.green,corNaoSelecionado=Colors.white;

  @override
  void initState() {
    dados =Get.arguments['dados'] ?? null;
    Dados.campos.clear();
    Dados.prepara(dados, 'nome',nome, true);

    ID =Dados.getIdProduto();
    tit =Get.arguments['tit'] ?? null;
    TB =Get.arguments['TB'] ?? null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:tit),
        bottomNavigationBar: BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(mostraCircular,0),
                child:mostraCircular?Circular(): Texto(tit:'salvar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                mostraCircular=true;
                setState(() {});
                salvar();
              },
            ),
          ),
        ),
        body:Form(
          key: Utils.formKeyPerfilPadrao,
          child:SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20,bottom: 10,left:2,right: 2),
                      child:Texto(tit:'Existem 2 tipos de itens adcionais',tam: 18,),
                    ),
                    Card(
                      color: escolhido?Colors.green:Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left:2,right: 2),
                              child:Texto(tit:'Múltiplas escolhas',tam: 18,negrito: true,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left:10,right: 2),
                              child:Texto(tit:'Quando o usuário pode escolher mais de uma opção. Ex.: Acompnahmento, pode-se escolher BATATA FRITA+MOLHO',
                                linhas: 3,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20,bottom: 10,left:2,right: 2),
                              child:Texto(tit:'Pressiona aqui para selecionar essa opção',cor:Utils.corApp,negrito: true,),
                            ),
                          ]
                      ),
                    ),

                    Card(
                      elevation: 6,
                      color: !escolhido?Colors.green:Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left:2,right: 2),
                              child:Texto(tit:'Única escolha',tam: 18,negrito: true,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left:10,right: 2),
                              child:Texto(tit:'Quando o usuário tem apenas uma opção. Ex.: Cor, pode-se escolher BRANCO, PRETO OU AZUL',
                                linhas: 2,),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20,bottom: 10,left:2,right: 2),
                              child:Texto(tit:'Pressiona aqui para selecionar essa opção',cor: Utils.corApp,negrito: true,),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 0,left:2,right: 2),
                  child:Edit(label: 'Descrição',hint: 'Descrição',campo: 'nome',controle: nome,alinhamento:TextAlign.left,),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void salvar() async{
    if (Utils.formKeyPerfilPadrao.currentState!.validate()) {
      mostraCircular=true;
      setState(() {});
      if (dados != null) {
        //ATUALIZANDO
        await Dados.databaseReference.collection(TB).doc(ID).update({'nome': nome.text});
      } else {
        //INCLUINDO
        await Dados.inserirDados(TB, context,'');
      }
      mostraCircular = false;
      setState(() {});
      Get.back();
    }
  }
  @override
  bool get wantKeepAlive => true;
}//136-95-83