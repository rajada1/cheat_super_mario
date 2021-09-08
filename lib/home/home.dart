import 'dart:typed_data';
import 'package:cheat_super_mario/functions/getProcessByName.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addVida(Pointer<NativeType> bitmapMemory) async {
    int address = bitmapMemory.address;

    print('SEM CONVERTER O ADDRESS' + '$bitmapMemory');
    print('CONVERTENDO PARA ADDRESS' + '${bitmapMemory.address}');

    var lpBaseAddress = Pointer.fromAddress(0x072C226);
    var lpBaseAddressOriginalAddress = Pointer.fromAddress(0x072C226);

    print(0x072C226.bitLength);
    var list = Uint8List.fromList([0xE9, 0x072C243]);
    var valorEscritoNoAddressOriginal = Uint8List.fromList([0xE9, address]);
    var hProcess;
    int? processID = await gerProcessIdByName('zsnesw.exe');
    processId = processID;
    if (processID != 0x0) {
      hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processID!);
    }
    print(list);
    final p = list.allocatePointer();
    // final endOriginal = valorEscritoNoAddressOriginal.allocatePointer();

    int escritaNaMemoriaAllocada = WriteProcessMemory(
      hProcess,
      lpBaseAddress,
      p,
      16,
      nullptr,
    );

    if (escritaNaMemoriaAllocada == 1) {
      print('Mem Allocada Escrita');
    } else {
      print('Mem Allocada Error');
    }

    // int jmpParaMemAllocada = WriteProcessMemory(
    //     hProcess, lpBaseAddressOriginalAddress, endOriginal, 32, nullptr);

    // if (jmpParaMemAllocada == 1) {
    //   print('ORIGINAL ADDRESS ESCRITO');
    // } else {
    //   print('Erro ao escrever no address Original');
    // }

    // lpBuffer.value = 0x2E;
    // lpBaseAddress = Pointer.fromAddress(0x072C224 + 1);
    // WriteProcessMemory(
    //   hProcess,
    //   lpBaseAddress,
    //   lpBuffer,
    //   32,
    //   nullptr,
    // );
    // ReadProcessMemory(
    //     hProcess, lpBaseAddress, p, sizeOf<Uint16>(), nullptr);
    // print(p.value);
  }

  alloMemory() async {
    var hProcess;
    int? processID = await gerProcessIdByName('zsnesw.exe');
    processId = processID;
    if (processID != 0x0) {
      hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, processID!);
    }
    var lpAddress = GetProcAddress(hProcess, 'zsnesw.exe'.toNativeUtf8());
    var lpBaseAddress = Pointer.fromAddress(lpAddress);
    final bitmapMemorySize = 1028;
    var bitmapMemory = VirtualAllocEx(hProcess, lpBaseAddress, bitmapMemorySize,
        MEM_COMMIT, PAGE_EXECUTE_READWRITE);

    // bitmapMemory = VirtualAlloc(bitmapMemory, bitmapMemorySize, MEM_COMMIT, PAGE_READWRITE);

    // VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    // var list = Uint8List.fromList([0xFF, 0xF3]);
    // var pointer = list.allocatePointer();
    // print(pointer.address);
    print(bitmapMemory);
    addVida(bitmapMemory);
    VirtualFreeEx(hProcess, lpBaseAddress, bitmapMemorySize, MEM_RELEASE);
  }

  int? processId = 0x0;
  bool frezar = false;
  String buttonText = 'Desativado';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AUMENTAR VIDA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Vida Infinita'),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    frezar ? Colors.green : Colors.red),
              ),
              onPressed: () async {
                alloMemory();
                // addVida(2504564932608);

                setState(() {});
                // frezar = !frezar;
                // frezar ? buttonText = 'Ativado' : buttonText = 'Desativado';
                // Timer myTime =
                //     Timer.periodic(Duration(milliseconds: 500), (timer) {
                //   if (frezar) {
                //     print('Ativado');
                //     addVida();
                //   } else {
                //     timer.cancel();
                //     print('Desativado');
                //   }
                // });
                // setState(() {});
              },
              child: Text(buttonText),
            ),
            Text('ProcessID is'),
            Text('${processId == 0x0 ? 'Processo Não Encontrado' : processId}')
          ],
        ),
      ),
    );
  }
}
