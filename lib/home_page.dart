import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cidade = "Murici";
  double opacidade = 0;
  var controle = TextEditingController();

  void getCidade() {
    setState(() {
      cidade = controle.text;
      opacidade = 1;
    });
  }

  Future<Map> getData() async {
    String url =
        'https://api.hgbrasil.com/weather?key=974d81e7&city_name=${Uri.encodeQueryComponent(cidade)}';
    var response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("City Climate"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: FutureBuilder(
            future: getData(),
            builder: (context, conexao) {
              switch (conexao.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  print('active');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  print('default');
                  print(conexao.connectionState);
                  if (conexao.hasError) {
                    return Column(
                      children: <Widget>[
                        Text("Deu errado..."),
                        IconButton(
                            icon:
                                Icon(Icons.home, color: Colors.green, size: 20),
                            onPressed: () {
                              setState(() {
                                cidade = " ";
                                opacidade = 0;
                              });
                            })
                      ],
                    );
                  } else
                    return Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: controle,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Digite uma Cidade"),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                          ),
                          Divider(
                            height: 20,
                          ),
                          RaisedButton(
                            child: Text(
                              "Pesquisar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                            onPressed: getCidade,
                          ),
                          Divider(
                            height: 20,
                          ),
                          AnimatedOpacity(
                            duration: Duration(seconds: 3),
                            opacity: opacidade,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text('Temperatura:'),
                                        Text('Data:'),
                                        Text('Condição:'),
                                          Text('Tempo atual:'),
                                          Text('Cidade'),
                                      ],
                                    ),
                                    Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(conexao.data["results"]["temp"]
                                            .toString()),
                                        Text(conexao.data["results"]["date"]
                                            .toString()),
                                            Text(conexao.data["results"]["description"]),
                                              Text(conexao.data["results"]["currently"]),
                                               
                                Text(conexao.data["results"]["city"]),
                                Text(conexao.data["results"]["img_id"]
                                    .toString()),
                                Text(conexao.data["results"]["humidity"]
                                    .toString()),
                                Text(conexao.data["results"]["wind_speedy"]
                                    .toString()),
                                Text(conexao.data["results"]["sunrise"]),
                                Text(conexao.data["results"]["sunset"]
                                    .toString()),
                                Text(conexao.data["results"]["condition_slug"]
                                    .toString()),
                                Text(conexao.data["results"]["city_name"]),
                                      ],
                                    ),
                                  ],
                                ),
                                // Text(conexao.data["results"]["condition_code"]
                                //     .toString()),
                                
                              
                               
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
              }
            },
          ),
        ));
  }
}
