import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mkplace/widget/texto.dart';

import 'lista_padrao.dart';

class ItemTB extends StatefulWidget {
  var tit,destino,tb;
  double? tam;
  Color? cor;

  ItemTB({
    this.tit,
    this.tam,
    this.cor,
    this.destino,
    this.tb,
  });

  @override
  _ItemTBState createState() => _ItemTBState();
}

class _ItemTBState extends State<ItemTB> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5,left:5,right: 5),
      child:OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 6,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Texto(tit:widget.tit,tam: widget.tam,cor:Colors.black,negrito: true,),
        onPressed: () {
          Get.to(() => ListaPadrao(), arguments: {'tit':widget.tit,'destino':widget.destino,'TB':widget.tb});
          },
      ),
    );
  }
}