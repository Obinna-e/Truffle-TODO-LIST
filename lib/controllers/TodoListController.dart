import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:todo_dapp/models/taskModel.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListController extends GetxController {
  List<Task> todos = <Task>[].obs;
  bool isLoading = true;
  late int taskCount;
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545/";

  //Ganache key
  final String? _privateKey = dotenv.env['PRIVATE_KEY'];

  late Web3Client _client;
  late String _abiCode;

  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  late EthereumAddress _ownAddress;
  late DeployedContract _contract;

  late ContractFunction _taskCount;
  late ContractFunction _todos;
  late ContractFunction _createTask;
  late ContractFunction _updateTask;
  late ContractFunction _deleteTask;
  late ContractFunction _toggleComplete;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle
        .loadString("smartcontract/build/contracts/TodoContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey!);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "TodoList"), _contractAddress);
    _taskCount = _contract.function("taskCount");
    _updateTask = _contract.function("updateTask");
    _createTask = _contract.function("createTask");
    _deleteTask = _contract.function("deleteTask");
    _toggleComplete = _contract.function("toggleComplete");
    _todos = _contract.function("todos");
    await getTodos();
  }

  getTodos() async {
    List totalTaskList = await _client
        .call(contract: _contract, function: _taskCount, params: []);

    BigInt totalTask = totalTaskList[0];
    taskCount = totalTask.toInt();
    todos.clear();
    for (var i = 0; i < totalTask.toInt(); i++) {
      var temp = await _client.call(
          contract: _contract, function: _todos, params: [BigInt.from(i)]);
      if (temp[1] != "")
        // ignore: curly_braces_in_flow_control_structures
        todos.add(
          Task(
            id: (temp[0] as BigInt).toInt(),
            taskName: temp[1],
            isCompleted: temp[2],
          ),
        );
    }
    isLoading = false;
    todos = todos.reversed.toList();
    update();
  }

  addTask(String taskNameData) async {
    isLoading = true;

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _createTask,
        parameters: [taskNameData],
      ),
    );
    await getTodos();
    update();
  }

  updateTask(int id, String taskNameDate) async {
    isLoading = true;
    update();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _updateTask,
        parameters: [BigInt.from(id), taskNameDate],
      ),
    );

    await getTodos();
    update();
  }

  deleteTask(int id) async {
    isLoading = true;
    update();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _deleteTask,
        parameters: [BigInt.from(id)],
      ),
    );
    await getTodos();
    update();
  }

  toggleComplete(int id) async {
    isLoading = true;
    update();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _toggleComplete,
        parameters: [BigInt.from(id)],
      ),
    );
    await getTodos();
    update();
  }
}
