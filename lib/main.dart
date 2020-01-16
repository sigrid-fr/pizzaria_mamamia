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
  String observacao, nome, flavor, tamanho;
  Sabor selectedSabor;
  bool aguaVal = false, refriVal = false, sucoVal = false, _validate = false;
  int selectedRadio, selectedRadioTile;

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

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
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


  //Botão enviar
  void _submit() {
    if (formKey.currentState.validate()) {
      // No any error in validation
      formKey.currentState.save();
      print("Nome do Cliente: $nome");
      print("Sabor da Pizza: $flavor");
      print("Tamanho da Pizza: $tamanho");
      print("Observação: $observacao");
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
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
          validator: validateString,
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

          RadioListTile(
            value: 1,
            groupValue: selectedRadioTile,
            title: Text("Média"),
            subtitle: Text("8 Fatias"),
            onChanged: (val) {
              setSelectedRadioTile(val);
              tamanho= ("Média");
            },
            activeColor: Colors.red,
          ),
          RadioListTile(
            value: 2,
            groupValue: selectedRadioTile,
            title: Text("Grande"),
            subtitle: Text("10 fatias"),
            onChanged: (val) {
              setSelectedRadioTile(val);
              tamanho= ("Grande");
            },
            activeColor: Colors.red,
          ),

          new Divider(
            height: 15.0,
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
            height: 15.0,
            color: Colors.transparent,
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // [Água] checkbox
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Água (500ml)"),
                  Checkbox(
                    value: aguaVal,
                    onChanged: (bool value) {
                      setState(() {
                        aguaVal = value;
                      });
                    },
                  ),
                ],
              ),

              // [Refrigerante] checkbox
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Refrigerante (2L)"),
                  Checkbox(
                    value: refriVal,
                    onChanged: (bool value) {
                      setState(() {
                        refriVal = value;
                      });
                    },
                  ),
                ],
              ),
              // [Suco] checkbox
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Suco (500ml)"),
                  Checkbox(
                    value: sucoVal,
                    onChanged: (bool value) {
                      setState(() {
                        sucoVal = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

              new Divider(
            height: 15.0,
            color: Colors.transparent,
          ),

        new TextFormField(
          decoration: new InputDecoration(labelText: 'Observação'),
          maxLength: 52,
          validator: validateString,
          onSaved: (String val) {
            observacao = val;
          },
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
        )
    ],
    ),
    ),
        ));
  }
}

String validateString(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (!regExp.hasMatch(value)) {
    return "O campo observação deve ser de a-z and A-Z";
  }
  return null;
}
