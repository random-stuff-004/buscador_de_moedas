import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/model/MoneyModel.dart';
import 'package:money_search/model/listPersonModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// instancia do modelo para receber as informações
List<ListPersonModel> model = [];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: FutureBuilder<List<ListPersonModel>>(
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
                    "https://s2.glbimg.com/daMdYJhpxpr5-E78FMlS90olKYw=/0x0:1500x1000/924x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_08fbf48bc0524877943fe86e43087e7a/internal_photos/bs/2022/m/d/anTjJ9RdAtAzpHlf6b0Q/filme-avatar-1.png",
                name: "Edu.Jr",
                id: "${model.length + 1}"));


            // buscando e removendo avatar
            model.forEach((element) {
              if (element.id == '11') {
                element.avatar = '';
              }
            });

            //buscando e alterando o avatar
            model.forEach((element) {
              if (element.id == '11') {
                element.avatar =
                    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.dreamstime.com%2Funknown-male-avatar-profile-image-businessman-vector-unknown-male-avatar-profile-image-businessman-vector-profile-image179373829&psig=AOvVaw1ZegF0wzVVa0TTj2GKIgY-&ust=1664115872797000&source=images&cd=vfe&ved=0CAgQjRxqFwoTCPC4otHQrfoCFQAAAAAdAAAAABAI';
              }
            });

            model.toSet(); //remove todos itens repetidos

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
          },
        ));
  }

  Future<Null> refresh() async {
    setState(() {});
  }
}
