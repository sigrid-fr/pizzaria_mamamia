import 'package:flutter/material.dart';

void main() => runApp(new PizzariaMamamia());

//Classe da Aplicação
class PizzariaMamamia extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new MaterialApp(
        title: "Pizzaria Mama Mia",
        theme: new ThemeData(primarySwatch: Colors.teal),
        home: new PaginaPrincipalPage());
  }
}

//Classe da Página Principal
class PaginaPrincipalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PaginaPrincipalState();
}

// Classe Sabor da Pizza
class Sabor {
  int saborId;
  String sabor;
  String ingredientes;

  // Construtor
  Sabor({this.saborId, this.sabor, this.ingredientes});

  //Titulo e subtitulos dos sabores da Pizza
  static List<Sabor> getSabores() {
    return <Sabor>[
      Sabor(saborId: 1, sabor: "Calabresa", ingredientes: "Molho especial, queijo, calabresa, cebola, azeitona, orégano"),
      Sabor(saborId: 2, sabor: "Frango", ingredientes: "Molho especial, queijo, frango, milho, azeitona, orégano"),
      Sabor(saborId: 3, sabor: "Pepperoni", ingredientes: "Molho especial, queijo, pepperoni, cebola, azeitona, orégano"),
    ];
  }
}


//Classe Estado da Página Principal
class _PaginaPrincipalState extends State<PaginaPrincipalPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String nome, flavor, tamanho, _newValue;
  Sabor selectedSabor;
  bool _validate; //validação dos campos do formulário
  //Variáveis usadas em conjunto com o CheckBox
  bool aguaVal = false, refriVal = false, sucoVal = false;

  //valores da pizza e das bebidas
  double t1 = 27.0, //pizza média
      t2 = 37.0, //pizza grande
      b1 = 4.00, //preço água
      b2 = 10.0, //preço refrigerante
      b3 = 6.00, //preço suco
      resultado = 0.0;

  //Map com os itens bebida do checkbox
  Map<String, bool> values = {
    'Água': false,
    'Refrigerante': false,
    'Suco': false,
  };

//variavel que vai receber os itens temporarios do checkbox
  var tmpArray = [];
//vai colocar os itens selecionados no tmpArray
  getCheckboxItems() {
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
  }

//Lista que vai receber os sabores
  List<Sabor> sabores;

  @override
  void initState() {
    super.initState();
    sabores = Sabor.getSabores();
  }

  setSelectedSabor(Sabor sabor) {
    setState(() {
      selectedSabor = sabor;
    });
  }

  List<Widget> createRadioListSabores() {
    List<Widget> widgets = [];
    for (Sabor sabor in sabores) {
      widgets.add(
        RadioListTile(
          value: sabor,
          groupValue: selectedSabor,
          title: Text(sabor.sabor),
          subtitle: Text(sabor.ingredientes),
          onChanged: (currentSabor) {
            setSelectedSabor(currentSabor);
            flavor = "${currentSabor.sabor}";
          },
          selected: selectedSabor == sabor,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }

//Mostra mensagem se nenhum sabor ou tamanho forem selecionados
  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Mama Mia Pizzaria"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),

          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Nome do Cliente'),
                  maxLength: 32,
                  validator: validateNome,
                  onSaved: (String val) {
                    nome = val;
                  },
                ),

             new Divider(
                  height: 7.0,
                  color: Colors.transparent,
                ),

             _texto ('Selecione o Sabor'),

             new Divider(
                  height: 15.0,
                  color: Colors.transparent,
                ),

            //RadioButton dos Sabores da Pizza
             new Column(
                  children: createRadioListSabores(),
                ),

              new Divider(
                  height: 25.0,
                  color: Colors.transparent,
                ),

                _texto ('Selecione o Tamanho'),

             new Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),

                //RadioButtons do tamanho da pizza
                Row(
                  children: <Widget>[
                    Flexible(
                      child: RadioListTile<String>(
                        value: 'Média',
                        title: Text('Média'),
                        subtitle: Text('(RS 27,00)'),
                        groupValue:  _newValue,
                        onChanged: (value) {
                          setState(() {
                            _newValue = value;
                            tamanho = value;
                            if(!aguaVal && !refriVal && !sucoVal && tamanho == 'Média') {
                              resultado = (t1); //quando nenhuma bebida for selecionada retornará só o preço da pizza Média
                            }
                          });
                        },
                        activeColor: Colors.red,
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        value: 'Grande',
                        title: Text('Grande'),
                        subtitle: Text('(RS 37,00)'),
                        groupValue: _newValue,
                        onChanged: (value) {
                          setState(() {
                            _newValue = value;
                            tamanho = value;
                            if(!aguaVal && !refriVal && !sucoVal && tamanho == 'Grande') {
                              resultado = (t2); // quando nenhuma bebida for selecionada retornará só o preço da pizza grande
                            }
                          });
                        },
                        activeColor: Colors.red,
                      ),
                    ),

                  ],
                ),


             new Divider(
                  height: 25.0,
                  color: Colors.transparent,
                ),

             _texto ('Selecione a(s) Bebida(s)'), //Campo não obrigatório

             new Divider(
                  height: 3.0,
                  color: Colors.transparent,
                ),

              new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    value: aguaVal,
                    onChanged: (value){
                      setState(() {
                        aguaVal = value;
                      });
                    },
                  ),
                  _textocheckbox('Água'),
                  _textopreco('  Mineral 500ml (RS 4,00)'),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: refriVal,
                    onChanged: (value){
                      setState(() {
                        refriVal = value;
                      });
                    },
                  ),
                  _textocheckbox('Refrigerante'),
                  _textopreco('  Coca 2L (RS 10,00)'),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: sucoVal,
                    onChanged: (value){
                      setState(() {
                        sucoVal = value;
                      });
                    },
                  ),
                  _textocheckbox('Suco'),
                  _textopreco('  Laranja 500ml (RS 6,00)'),
                ],
              ),

              new Divider(
                height: 15.0,
                color: Colors.transparent,
              ),

              //Salva e Valida os dados
              RaisedButton(
                child: Text('ENVIAR',
                style: new TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: (){
                  //Retorna o preço de acordo com os itens selecionados e coloca as bebidas selecionadas na tmArray
                  if (aguaVal && tamanho=='Média') {
                    resultado = (t1 + b1);
                    getCheckboxItems();
                    tmpArray = ['Água'];
                  }
                  if(aguaVal && tamanho=='Grande') {
                    resultado = (t2 + b1);
                    getCheckboxItems();
                    tmpArray = ['Água'];
                  }
                  if(refriVal && tamanho == 'Média'){
                    resultado = (t1 + b2);
                    getCheckboxItems();
                    tmpArray = ['Refrigerante'];
                  }
                  if(refriVal && tamanho == 'Grande'){
                    resultado = (t2 + b2);
                    getCheckboxItems();
                    tmpArray = ['Refrigerante'];
                  }
                  if(sucoVal && tamanho == 'Média') {
                    resultado = (t1 + b3);
                    getCheckboxItems();
                    tmpArray = ['Suco'];
                  }
                  if(sucoVal && tamanho == 'Grande') {
                    resultado = (t2 + b3);
                    getCheckboxItems();
                    tmpArray = ['Suco'];
                  }
                  if(aguaVal && refriVal && tamanho == 'Média') {
                    resultado = (t1 + b1 + b2);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Refrigerante'];
                  }
                  if (aguaVal && refriVal && tamanho == 'Grande') {
                    resultado = (t2 + b1 + b2);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Refrigerante'];
                  }
                  if(aguaVal && sucoVal && tamanho == 'Média') {
                    resultado = (t1 + b1 + b3);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Suco'];
                  }
                  if(aguaVal && sucoVal && tamanho == 'Grande') {
                    resultado = (t2 + b1 + b3);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Suco'];
                  }
                  if(refriVal && sucoVal && tamanho == 'Média') {
                    resultado = (t1 + b2 + b3);
                    getCheckboxItems();
                    tmpArray = ['Refrigerante', 'Suco'];
                  }
                  if(refriVal && sucoVal && tamanho == 'Grande') {
                    resultado = (t2 + b2 + b3);
                    getCheckboxItems();
                    tmpArray = ['Refrigerante', 'Suco'];
                  }
                  if(aguaVal && refriVal && sucoVal && tamanho == 'Média') {
                    resultado = (t1 + b1 + b2 + b3);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Refrigerante', 'Suco'];
                  }
                  if(aguaVal && refriVal && sucoVal && tamanho == 'Grande') {
                    resultado = (t2 + b1 + b2 + b3);
                    getCheckboxItems();
                    tmpArray = ['Água', 'Refrigerante', 'Suco'];
                  }
                  // Quando nenhum tamanho for selecionado
                  if (_newValue == null) {
                    _showSnackBar('Por favor, selecione um tamanho!');
                  }
                  // Se nenhum dos sabores forem selecionados
                  if (selectedSabor == null) {
                    _showSnackBar("Por favor, selecione um sabor!");
                  }
                  // Se não forem encontrados erros na validação exibe o recibo
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    print("######################## RECIBO ########################");
                    print("Nome Completo: $nome");
                    print("Sabor da Pizza: $flavor");
                    print("Tamanho da Pizza: $tamanho");
                    print("A(s) Bebida(s): $tmpArray");
                    tmpArray.clear();
                    print("O preço a pagar é: RS $resultado");
                    print("########################################################");
                    print("\n");
                  }// Em caso de erro de validação
                  else {
                    setState(() {
                      _validate = true;
                    });
                  }
                },
              )
            ],
          ),

            new Padding(
               padding: const EdgeInsets.only(top: 20.0),
               ),
              ],
            ),
          ),
        ));
  }
}

//Validação do Campo Nome
String validateNome(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'O nome é obrigatório!';
  }
  else if (!regExp.hasMatch(value)) {
    return "O nome deve ser de a-z and A-Z";
  }
  return null;
}

//Método dos Textos em Negrito
_texto(String mensagem){
  return Text(mensagem, style: TextStyle(
    fontSize: 16.5,
    fontWeight: FontWeight.bold,
  ),);
}

//subtitulo do preco do checkbox
_textopreco(String mensagem){
  return Text(mensagem, style: TextStyle(
    fontSize: 14,
    color: Colors.black54,
  ),);
}

//Método dos Textos do Checkbox
_textocheckbox(String mensagem){
  return Text(mensagem, style: TextStyle(
    fontSize: 16,
  ),);

}
