import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final valor = TextEditingController();
  final isValidade = GlobalKey<FormState>();
  String novoItem = '';
  List<bool> checkboxStates = [];
  List compras = [];

  void removeItem(value) => {
        setState(() {
          compras.removeAt(value);
        })
      };

  void addItem(value) {
    setState(() {
      compras.add({"name": value, "isBought": false});
      checkboxStates.add(false); 
      valor.clear(); 
    });
  }

  void editItem(int index, String name){
    setState(() {
    compras.setAll(index, [
      {
        "name": name
      }
    ]);   
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Compras',
          style: GoogleFonts.roboto(),
        ),
      ),
      body:
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: isValidade,
                  child: TextFormField(
                    controller: valor,
                    onFieldSubmitted: (value) {
                      addItem(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'nao pode';
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: 'Digite um item',
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isValidade.currentState!.validate()) {
                        setState(() {
                          addItem(valor.text);
                          valor.clear();
                        });
                      }
                    },
                    child: const Text('Adicionar Item'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: compras.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            compras[index]['name'],
                            style: checkboxStates[index]
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough)
                                : null,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Edição de item'),
                                content: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Novo item',
                                  ),
                                  onChanged: (value) {
                                    novoItem = value;
                                   
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      editItem(index, novoItem);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Salvar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      Checkbox(
                          value: checkboxStates[index], 
                          onChanged: (bool? newValue) {
                            setState(() {
                              checkboxStates[index] =
                                  newValue!;
                            });
                          }),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        onPressed: () {
                          removeItem(index);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}