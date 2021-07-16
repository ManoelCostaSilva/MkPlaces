import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';
import 'autentica.dart';

class BemVindo extends StatefulWidget {
  @override
  BemVindoState createState() => BemVindoState();

}

class BemVindoState extends State<BemVindo> {
  String url='https://firebasestorage.googleapis.com/v0/b/mkjobs-38a22.appspot.com/o/DOC%2F0K7LJ1v76NKKDRZZWUVQ.jpeg?alt=media&token=422c0669-9d59-4554-b06c-824930d926b0';
  File? _image;

  @override
  void initState() {
   // Utils.uploadFile('RfEHfbsf7D4UyVo3rEYy', _image, 'man_empresa', context,'DOC','.jpeg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:'bem_vindo'.tr,center: true,),
      body:Form(
        child:SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height : 10.0),

              MkBoxDecoration(image:_image,url:url,carregaImg: false,),

              //CLIENTE ************************************************
              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 10,left:2,right: 2),
                child:Texto(tit:'sou_cliente'.tr,tam:18,cor:Utils.corApp),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 20,left:2,right: 2),
                child:OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Utils.corApp,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Texto(tit:'conhecer_maq'.tr,tam: 20,cor:Colors.white),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => FornecedorLista()));
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 20,left:12,right: 2),
                child: const Divider(
                  color: Colors.grey, height: 2, thickness: 2, indent: 10, endIndent: 10,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 0,bottom: 10,left:2,right: 2),
                child:Texto(tit:'sou_revendedor'.tr,tam: 18,cor: Utils.corApp ,),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10,bottom: 20,left:2,right: 2),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Utils.corApp,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Texto(tit:'quero_vender'.tr,tam: 20,cor:Colors.white),
                  onPressed: () {
                    Get.to(() => Autentica());
                    //usando essa opção não volta pra tela anterior
                    //Get.off(PageTwo()),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

