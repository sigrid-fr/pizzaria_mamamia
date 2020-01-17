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

// Classe sabor dos RadioButtons
class Sabor {
  int saborId;
  String sabor;
  String ingredientes;

  Sabor({this.saborId, this.sabor, this.ingredientes});

  static List<Sabor> getSabores() {
    return <Sabor>[
      Sabor(saborId: 1, sabor: "Calabresa", ingredientes: "Molho zone, queijo, calabresa, cebola, azeitona, orégano"),
      Sabor(saborId: 2, sabor: "Frango", ingredientes: "Molho zone, queijo, frango, milho, azeitona, orégano"),
      Sabor(saborId: 3, sabor: "Pepperoni", ingredientes: "Molho zone, queijo, pepperoni, cebola, azeitona, orégano"),
    ];
  }
}

//Classe Estado da Página Principal
class _PaginaPrincipalState extends State<PaginaPrincipalPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String nome, flavor, tamanho, _newValue;
  List <String> bebida = [];
  Sabor selectedSabor;
  bool _aguaVal = false, _refriVal = false, _sucoVal = false, _validate = false;

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

  //Botão enviar e validação
  void _submit() {
    if (_newValue == null) {
      // Quando nenhum tamanho for selecionado
      _showSnackBar('Por favor, selecione um tamanho!');
    } else if (selectedSabor == null) {
      // Se nenhum dos sabores forem selecionados
      _showSnackBar("Por favor, selecione um sabor!");
    } else if (formKey.currentState.validate()) {
          // Se não forem encontrados erros na validação
          formKey.currentState.save();
          print("Nome do Cliente: $nome");
          print("Sabor da Pizza: $flavor");
          print("Tamanho da Pizza: $tamanho");
          print("A(s) Bebida(s): $bebida");
      } else {
        // Em caso de erro de validação, o campo bebidas não é obrigatório
        setState(() {
          _validate = true;
        });
      }
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
            height: 5.0,
            color: Colors.transparent,
          ),

        new Text(
            'Selecione o Sabor',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
            )
          ),

          new Divider(
            height: 15.0,
            color: Colors.transparent,
          ),

        new Column(
              children: createRadioListSabores(),
        ),

        new Divider(
            height: 20.0,
            color: Colors.transparent,
          ),

          new Text(
              'Selecione o tamanho',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )
          ),

          new Divider(
            height: 15.0,
            color: Colors.transparent,
          ),


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
                    });
                  },
                  activeColor: Colors.red,
                ),
              ),

            ],
          ),


          new Divider(
            height: 17.0,
            color: Colors.transparent,
          ),

          new Text(
              'Bebidas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              )
          ),

          new Divider(
            height: 3.0,
            color: Colors.transparent,
          ),

          new Column(
            children: <Widget>[
              // [Água] checkbox
              CheckboxListTile(
                activeColor: Colors.blueAccent,
                value: _aguaVal,
                onChanged: (newValue) {
                  setState(() {
                    _aguaVal = newValue;
                    bebida = (['Água']);
                  });
                },
                title: Text('Água',
                       style: TextStyle(
                       fontSize: 16.0,
                  ),
                ),
                subtitle: Text('Mineral 500ml (RS 6,00)'),
                controlAffinity: ListTileControlAffinity.platform,
              ),
              // [Refrigerante] checkbox
              CheckboxListTile(
                activeColor: Colors.blueAccent,
                value: _refriVal,
                onChanged: (newValue) {
                  setState(() {
                    _refriVal = newValue;
                    bebida = (['Refrigerante']);
                  });
                },
                title: Text('Refrigerante',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text('Coca 2L (RS 10,00)'),
                controlAffinity: ListTileControlAffinity.platform,
              ),
              // [Suco] checkbox
              CheckboxListTile(
                activeColor: Colors.blueAccent,
                value: _sucoVal,
                onChanged: (newValue) {
                  setState(() {
                    _sucoVal = newValue;
                    bebida = (['Suco']);
                  });
                },
                title: Text('Suco',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text('Laranja 500ml (RS 8,00)'),
                controlAffinity: ListTileControlAffinity.platform,
              ),
            ],
          ),

        new Padding(
          padding: const EdgeInsets.only(top: 20.0),
        ),

        new RaisedButton(
          child: new Text(
            "enviar",
            style: new TextStyle(color: Colors.white),
        ),
          color: Colors.blue,
          onPressed: _submit,
          ),
        new Divider(
           height: 10.0,
           color: Colors.transparent,
          ),
        ],
      ),
    ),
  ));
  }
}

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
