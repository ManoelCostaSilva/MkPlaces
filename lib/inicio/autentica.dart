import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:mkplace/empresas/empresa_login.dart';
import 'package:mkplace/empresas/empresa_perfil_doc.dart';
import 'package:mkplace/utils/utils.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:mkplace/widget/mk_BoxDecoration.dart';
import 'package:mkplace/widget/texto.dart';

class Autentica extends StatefulWidget {
  @override
  AutenticaState createState() => AutenticaState();
}

class AutenticaState extends State<Autentica> {
  File? _image;
  String url='https://firebasestorage.googleapis.com/v0/b/mkjobs-38a22.appspot.com/o/DOC%2F0K7LJ1v76NKKDRZZWUVQ.jpeg?alt=media&token=422c0669-9d59-4554-b06c-824930d926b0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BarraStatus(tit:'autenticacao'.tr),
        body: Center(

          child:Form(
            child:SingleChildScrollView(
              child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child:MkBoxDecoration(image:_image,url:url,carregaImg: false,),
                        ),

                        SizedBox(height : 40.0),
                        const Divider(color: Colors.grey, height: 2, thickness: 2, indent: 10, endIndent: 10,),

                        Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 10,left:12,right: 2),
                          child:Texto(tit:'negocio_proprio'.tr,
                            linhas: 2,negrito: true,cor: Utils.corApp,),
                        ),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              elevation: 6,
                              backgroundColor: Utils.corApp,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Texto(tit:'criar_empresa'.tr,tam: 20,cor:Colors.white),
                          onPressed: () {
                            Get.to(() => EmpresaPerfilDoc(), arguments: {'dados':null,});
                            },
                        ),

                        SizedBox(height : 20.0),
                        const Divider(color: Colors.grey, height: 2, thickness: 2, indent: 10, endIndent: 10,),
                        SizedBox(height : 15.0),

                        //************    Quando a empresa ou pessoa já é cadastrada
                        Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 10,left:12,right: 2),
                          child:Texto(tit:'sou_cadastrado'.tr,
                            linhas: 2,negrito: true,cor: Utils.corApp,),
                        ),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              elevation: 6,
                              backgroundColor: Utils.corApp,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Texto(tit:'login_as_empresa'.tr,tam: 20,cor:Colors.white),
                          onPressed: () {
                            Get.to(() => EmpresaLogin(), arguments: {'dados':null});
                          },
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              elevation: 6,
                              backgroundColor: Utils.corApp,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Texto(tit:'login_as_colaborador'.tr,tam: 20,cor:Colors.white),
                          onPressed: () {
                          //  Get.to(() => EmpresaLogin(), arguments: {'dados':null});
                          },
                        ),

                      ],
                    ),
            ),
          ),
        )
    );
  }
}