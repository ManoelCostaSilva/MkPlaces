import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mkplace/widget/texto.dart';

class BtnLista extends StatefulWidget {
  var tit,destino,ID,dados;
  double? tam;
  Color? cor,iconCor;
  dynamic? icon;

  BtnLista({
    this.tit,
    this.tam,
    this.cor,
    this.destino,
    this.ID,
    this.icon,
    this.iconCor,
    this.dados,
  });

  @override
  _BtnListaState createState() => _BtnListaState();
}

class _BtnListaState extends State<BtnLista> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0,left:3,right: 3),
        child:InkWell(
          onTap: () {
            Get.toNamed(widget.destino,arguments: {'id': widget.ID,'dados':widget.dados});
          },
          child:Column(
              children: <Widget>[
                IconButton(
                  color: widget.iconCor, icon: new Icon(widget.icon,),
                  onPressed: () {
                    Get.toNamed(widget.destino,arguments: {'id': widget.ID,'dados':widget.dados});
                  },
                ),
                Texto(tit:widget.tit,tam: widget.tam,cor:Colors.black,linhas: 2,),
              ]
          ),
        )
    );
  }
}