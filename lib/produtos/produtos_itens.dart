import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mkplace/dados/dados.dart';
import 'package:mkplace/utils/currency_input_formatter.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/circular.dart';
import 'package:mkplace/widget/edit.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';

class ProdutosItens extends StatefulWidget {

  @override
  _ProdutosItensState createState() => _ProdutosItensState();
}

class _ProdutosItensState extends State<ProdutosItens> with AutomaticKeepAliveClientMixin<ProdutosItens> {
  final descri = TextEditingController();
  final valor = TextEditingController();
  final teste = TextEditingController();
  var TB,dados,nomeItem='';
  bool mostraCircular=false,padrao=false;


  getIni()async{
    dados =Get.arguments['dados'] ?? null;
    Dados.campos.clear();
    Dados.prepara(dados, 'descri',descri, true);
    Dados.prepara(dados, 'valor',valor, false);
    Dados.prepara(dados, 'padrao',teste, false);
    TB ='man_produtos_add';
    Dados.setDadosParaGravaCliente('padrao', 'false');

    if(dados!=null){
      nomeItem=dados['nome'];
      setState(() {});
    }
  }
  @override
  void initState() {
    getIni();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BarraStatus(tit:nomeItem),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child: OutlinedButton(
              style: Utils.OutlinedButtonStlo(mostraCircular,0),
              child:mostraCircular?Circular(): Texto(tit:'salvar'.tr,negrito: true,tam: 17,cor:Colors. white,linhas: 2,),
              onPressed: () {
                mostraCircular=true;
                setState(() {});
                salvar();
              },
            ),
          ),
        ),

        body:Form(
          key: Utils.formKeyProdutosItens,
          child:SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // DESCRIÇÂO ****************************************
                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 0,left:2,right: 2),
                  child:Edit(label: 'Descrição',hint: 'Descrição',campo: 'descri',controle: descri,alinhamento:TextAlign.left),
                ),
                //VALOR
                Padding(
                  padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                  child:Edit(label: 'vr_vista'.tr,hint: 'vr_vista'.tr,controle: valor,
                    mask:FilteringTextInputFormatter.digitsOnly,
                    mask1: FormatoValorNumerico(maxDigits: 8),input:TextInputType.number,campo: 'valor',),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 0,bottom: 0,left:15,right: 0),
                  child:Row(
                    children: <Widget>[
                      Texto(tit: 'padrao'.tr,tam: 18,negrito:true,cor: Utils.corApp,),
                      Switch(
                      value: padrao,
                      onChanged: (value) {
                        setState(() {
                          Dados.setDadosParaGravaCliente('padrao', value.toString());
                          padrao = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void salvar() async {
    if (Utils.formKeyProdutosItens.currentState!.validate()) {
      mostraCircular=true;
      setState(() {});
      await Dados.inserirDados(TB, context,dados.id);
      mostraCircular = false;
      setState(() {});
      Get.back();
    }
  }
  @override
  bool get wantKeepAlive => true;
}//136