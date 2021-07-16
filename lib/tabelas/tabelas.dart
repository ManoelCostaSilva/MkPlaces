import 'package:flutter/material.dart';
import 'package:mkplace/widget/barra_status.dart';
import 'package:get/get.dart';
import 'tabelas_item.dart';

void main() => runApp(Tabelas());

class Tabelas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:'tabelas'.tr),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //ESTADO CIVIL
              ItemTB(tit:'Estado civil',destino: 'ESTADO_CIVIL',tam: 18,tb: 'man_estadoCivil',),
              //TIPO DE RESIDENCIA
              ItemTB(tit:'Tipo de residência',destino: 'TIPO_RESIDENCIA',tam: 18,tb: 'man_tipoResidencia',),
              //BANCODS
              ItemTB(tit:'Bancos',destino: 'BANCOS',tam: 18,tb: 'man_bancos',),
              //STATUS PEDIDO
              ItemTB(tit:'Status Pedido',destino: 'ST_PEDIDOS',tam: 18,tb:'man_stPedido'),
              //TIPO DE IMAGEM
              ItemTB(tit:'Tipo de imagem',destino: 'TIPO_IMAGEM',tam: 18,tb:'man_tipoImagem'),
              //TABELAS DE PREÇO
              ItemTB(tit:'Tabelas de preço',destino: 'TB_PRECO',tam: 18,tb: 'man_tabelaPreco',),
              //RAMO DE ATIVIDADE
              ItemTB(tit:'Ramo de atividade',destino: 'perfil_padrao',tam: 18,tb: 'man_ramoAtividade',),
              //OPERADORAS
              ItemTB(tit:'Operadoras',destino: 'OPERADORAS',tam: 18,tb: 'man-operadoras',),
              //MÁQUINAS
              ItemTB(tit:'Máquinas',destino: 'MAQUINAS',tam: 18,tb: 'man_maquinas',),
              //CONTAS
              ItemTB(tit:'Contas',destino: 'CONTAS',tam: 18,tb: 'man_contas',),
              //FORNECEDOR DA MÁQUINA
              ItemTB(tit:'Fornecedor',destino: 'FORNECEDOR',tam: 18,tb: 'man_fornecedores',),
            ],
          ),
        ],
      ),
    );
  }
}