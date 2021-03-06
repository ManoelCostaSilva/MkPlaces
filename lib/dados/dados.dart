import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/texto.dart';
import 'package:get/get.dart';
import 'campos.dart';

class Dados {
  static final databaseReference = FirebaseFirestore.instance;
  static final datacount = GetStorage();

  static List<Campos> campos = [];

  static prepara(var dados,String campo,dynamic controle,bool obrigatorio){
    try{
      campos.add(Campos(campo, dados[campo],obrigatorio),);
      controle.text=dados[campo];
    } catch (e) {
      //não tem o campo
      campos.add(Campos(campo, '', obrigatorio),);
      controle.text='';
    };
  }

  static setDadosParaGravaCliente(String? cp,String? vr){
    final tile = campos.firstWhere((item) => item.campo == cp);
    tile.valor = vr!;
  }

  static Future<dynamic> inserirDados(String TB,BuildContext context,String idItem) async {

    Map<String,String> toGravar={};

    var idEmpresa = await getIdEmpresa();

    //SÓ USA ESSA CAMPO SE FOR A TABELA man_produtos_add
    var idPro='';
    if(TB=='man_produtos_add') {
      idPro=getIdProduto();
    }
    for (var x = 0; x < campos.length; x++) {
      if (campos[x].valor !='') {
        toGravar[campos[x].campo]=campos[x].valor;
      }
    }
    //GRAVA OS DADOS OPCIONAIS
    DocumentReference ref;
    if(idItem=='') {
      ref = await Dados.databaseReference.collection(TB).add(toGravar,);
    }else{
      ref=await Dados.databaseReference
          .collection(TB)
          .doc(idItem)
          .collection("itens")
          .add(toGravar);
      String ch=ref.id.toString();

      await Dados.databaseReference.collection(TB).doc(idItem).collection('itens').doc(ch).update({
        'status': 'A',
        'dtCriado': FieldValue.serverTimestamp(),
        'dtAlterado': FieldValue.serverTimestamp(),
      });
    }

    String chave=ref.id.toString();

    if(idItem=='') {
      //GRAVA OS DADOS PADRÕES
      await Dados.databaseReference.collection(TB).doc(chave).update({
        'status': 'A',
        'img': '',
        'dtCriado': FieldValue.serverTimestamp(),
        'dtAlterado': FieldValue.serverTimestamp(),
        'idEmpresa': idEmpresa,
        'idProduto':idPro,
      });
    }

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');await Utils.uploadFile(ref.id, img, TB, context,'DOC','.jpeg');
    }else{
     // Utils.snak('parabens'.tr, 'sucesso'.tr, true,Colors.green);
    }
    return chave;
  }

  static Future<dynamic> atualizaDados(String TB,BuildContext context,String? id) async {
    Map<String,String> toGravar={};
    toGravar.clear();
    for (var x = 0; x < campos.length; x++) {
      if (campos[x].valor !='') {
        toGravar[campos[x].campo]=campos[x].valor;
      }
    }

    await Dados.databaseReference.collection(TB).doc(id).update(toGravar);
    await Dados.databaseReference.collection(TB).doc(id).update({'dtAtualizado':FieldValue.serverTimestamp()});

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');
      await Utils.uploadFile(id, img, TB, context,'DOC','.jpeg');
    }else{
      Utils.snak('parabens'.tr, 'sucesso'.tr, false, Colors.green);
    }
  }

  static setIdProduto(String idPro){
    datacount.write('idProduto',idPro);
  }

  static getIdProduto(){
    String id=datacount.read('idProduto');
    return id;
  }

  static getIdEmpresa(){
    String id=datacount.read('idDoc');
    return id;
  }

  static Future<dynamic> getdadosEmpresa() async {
    String id=datacount.read('idDoc');

    var empresa;
    empresa = await Dados.getData('man_empresa', 'doc', id, 'nome');
    if(empresa==null){
      return null;
    }else {
      return empresa;
    }
  }

  static atualizaSenha(String TB,String senha,String ID)async {
    await Dados.databaseReference.collection(TB).doc(
        ID).update({'senha': senha, 'dtAlterado': FieldValue.serverTimestamp()});
  }

  static ativarDesativar(String id,String st,String TB,String sub) async{
    try {
      String stTmp;
      if(st=='A'){
        stTmp='I';
      }else{
        stTmp='A';
      }
      if(TB=='man_produtos_add'){
        await databaseReference.collection(TB).doc(sub).collection('itens').doc(id) .update({'status': stTmp});
      }else {
        await databaseReference.collection(TB).doc(id).update({'status': stTmp});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static del(String id,String TB,BuildContext context,String sub) async{
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Texto(tit:'atencao'.tr,negrito: true,cor: Utils.corApp,tam: 20,),
          content: new Text('del_confirm'.tr),
          actions: <Widget>[
            OutlinedButton(
              style: Utils.OutlinedButtonStlo(false,6),
              child: Texto(tit:'nao'.tr,tam: 15,cor:Colors.white),
              onPressed: () {
                Get.back();
              },
            ),

            OutlinedButton(
            style: Utils.OutlinedButtonStlo(false,0),
              child: Texto(tit:'sim'.tr,tam: 15,cor:Colors.white),
              onPressed: () {
              Get.back();
              if(TB=='man_produtos_add'){
                databaseReference.collection(TB).doc(sub).collection('itens').doc(id).delete();
              }else{
                databaseReference.collection(TB).doc(id).delete();
              }
              },
            ),
          ],
        ));
  }

  static Future<dynamic> getData(String TB,String CAMPO,String ID,String ORDER) async {

    QuerySnapshot qn = await databaseReference.collection(TB)
        .where(CAMPO, isEqualTo: ID).orderBy(ORDER)
        .get();

    var dados;

    for (int i = 0; i < qn.docs.length; i++) {
      dados = qn.docs[i];
    }
    return dados;
  }

  static Future<dynamic> getLogado(String TB,String USER,String SENHA,String ORDER) async {
    QuerySnapshot qn = await databaseReference.collection(TB)
        .where('nome', isEqualTo: USER)
        .where('senha', isEqualTo: SENHA).orderBy(ORDER)
        .get();
    return qn.docs;
  }

  static Future<dynamic> getCom2Where(String TB,String CP1,String VR1,
      String CP2,String VR2,String ORDER) async {

    QuerySnapshot qn = await databaseReference.collection(TB)
        .where(CP1, isEqualTo: VR1)
        .where(CP2, isEqualTo: VR2).orderBy(ORDER)
        .get();
    return qn.docs;
  }

  static chamaPedidos(String status, String idPedido,BuildContext context,String cpfCliente
  ,List<dynamic>? tabs,bool admin,String tipoPedido,bool adm) async {

    var dadosPedido = await Dados.getData('man_pedidos', 'idPedido', idPedido, 'dtAtualizado');
    var dadosCliente = await Dados.getData('man_clientes', 'cpf', cpfCliente, 'nmCli');


    switch (dadosPedido['tipoPedido']) {
      case 'C6Pay':
        //final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => C6PayMain(
          //dadosCliente: dadosCliente,dadosPedido:dadosPedido,cpf: cpfCliente,individual: admin,adm: adm,)));
        break;

      /*
        case 'Refinanciamento':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => RefinanciamentoMain(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,)));
          break;
        case 'Empréstimo Pessoal':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => MainPedidosForm(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,)));
          break;

        case 'Consignado':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => ConsignadoMain(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,idPedido: idPedido,)));
          break;

       */
      }
  }

  static String doubleToReal(double vr) {
    var oCcy = new NumberFormat("#,##0.00", "pt_BR");
    var vrM = "R\$ " + oCcy.format(vr);
    return vrM;
  }

  static double vrDouble(String vr){
    String v='';
    v = vr.replaceAll('.', '#');
    v = v.replaceAll(',', '.');
    v = v.replaceAll('#', '');
    return double.parse(v);
  }
}// 262