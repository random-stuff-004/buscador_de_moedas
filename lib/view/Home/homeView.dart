import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/cache.dart';
import 'package:money_search/data/string.dart';
import 'package:money_search/model/MoneyModel.dart';
import 'package:money_search/model/listPersonModel.dart';

import '../../data/internet.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// instancia do modelo para receber as informações
List<ListPersonModel> model = [];

class _HomeViewState extends State<HomeView> {
  checkConnection() async {
    internet = await CheckInternet().checkConnection();
    if (internet == false) readMemory();
    setState(() {});
  }

  bool internet = true;

  @override
  //tudo que for colocado aqui dentro será executado assim que abrir a tela ou seja quando nosso estado for iniciado
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: [
            Visibility(
                visible: internet == false,
                child: Icon(Icons.network_cell_outlined))
          ],
        ),
        body: internet == false
            ? ListView.builder(
                itemCount: model.length,
                itemBuilder: (context, index) {
                  ListPersonModel item = model[index];
                  return ListTile(
                    leading: Image.network(item.avatar ?? ""),
                    title: Text(item.name ?? ""),
                    trailing: Text(item.id ?? ""),
                  );
                })
            : FutureBuilder<List<ListPersonModel>>(
                future: MoneyController().getListPerson(),
                builder: (context, snapshot) {
                  /// validação de carregamento da conexão
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// validação de erro
                  if (snapshot.error == true) {
                    return SizedBox(
                      height: 300,
                      child: Text("Vazio"),
                    );
                  }
                  //  List<ListPersonModel> model = [];
                  /// passando informações para o modelo criado
                  model = snapshot.data ?? model;
                  model.sort(
                    (a, b) => a.name!.compareTo(b.name!),
                  );

                  //adicionando uma nova pessoa na lista
                  model.add(ListPersonModel(
                      avatar:
                          "https://avatars.githubusercontent.com/u/78483701?v=4",
                      name: "Edu.Jr",
                      id: "${model.length + 1}"));

                  // buscando e removendo avatar
                  /*
                  // model.forEach((element) {
                  //   if (element.id == '11') {
                  //     element.avatar = '';
                  //   }
                  // });

                  // //buscando e alterando o avatar
                  // model.forEach((element) {
                  //   if (element.id == '11') {
                  //     element.avatar =
                  //         'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.dreamstime.com%2Funknown-male-avatar-profile-image-businessman-vector-unknown-male-avatar-profile-image-businessman-vector-profile-image179373829&psig=AOvVaw1ZegF0wzVVa0TTj2GKIgY-&ust=1664115872797000&source=images&cd=vfe&ved=0CAgQjRxqFwoTCPC4otHQrfoCFQAAAAAdAAAAABAI';
                  //   }
                  // });
*/
                  model.toSet(); //remove todos itens repetidos

                  verifyData(snapshot);
                  return ListView.builder(
                      itemCount: model.length,
                      itemBuilder: (context, index) {
                        ListPersonModel item = model[index];
                        return ListTile(
                          leading: Image.network(item.avatar ?? ""),
                          title: Text(item.name ?? ""),
                          trailing: Text(item.id ?? ""),
                        );
                      });
                  /*
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   // physics: NeverScrollableScrollPhysics(),
                  //   itemCount: model.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     ListPersonModel item = model[index];
                  //     // tap(ListPersonModel item) {
                  //     //   Navigator.push(
                  //     //       context,
                  //     //       MaterialPageRoute(
                  //     //           builder: (context) => Person(
                  //     //                 item: item,
                  //     //               )));
                  //     // }

                  //     return GestureDetector(
                  //       // onTap: (() => tap(item)),
                  //       child: ListTile(
                  //         leading: Image.network(item.avatar ?? ""),
                  //         title: Text(item.name ?? ""),
                  //         trailing: Text(item.id ?? ""),
                  //       ),
                  //     );
                  //   },
                  // );
                  */
                },
              ));
  }

  verifyData(AsyncSnapshot snapshot) async {
    try {
      // model.clear();
      model.addAll(snapshot.data ?? []);
      await SecureStorage()
          .writeSecureData(pessoas, json.encode(snapshot.data));
    } catch (e) {
      print("Erro ao salvar lista");
    }
  }

  readMemory() async {
    var result = SecureStorage().readSecureData(pessoas);
    if (result == null) return;
    List<ListPersonModel> lista = (json.decode(result) as List)
        .map((e) => ListPersonModel.fromJson(e))
        .toList();
    model.addAll(lista);
  }

  Future<Null> refresh() async {
    setState(() {});
  }
}
