class ClientModel {
  final int id;
  final String name;

  const ClientModel({required this.id, required this.name});
}

const List<ClientModel> kClients = [
  ClientModel(id: 100, name: 'Joseph Carlton'),
  ClientModel(id: 200, name: 'Maria Juarez'),
  ClientModel(id: 300, name: 'Albert Kenny'),
  ClientModel(id: 400, name: 'Jessica Phillips'),
  ClientModel(id: 500, name: 'Charles Johnson'),
];
