import 'dart:io';

///Get ProcessId by name ex: getProcessIdByName(notepad.exe) => pid;
Future<int?> gerProcessIdByName(String processName) async {
  String? finalPID = '';
  await Process.run('tasklist /V /FI "IMAGENAME eq $processName"', [])
      .then((ProcessResult results) {
    String getpid = results.stdout;
    String pid = getpid.replaceAll(RegExp(r'\s'), '');
    pid = pid.replaceAll('=', '');
    RegExp regExp = RegExp('$processName\\d+');
    finalPID = regExp.stringMatch(pid)?.replaceAll('$processName', '');
  });
  if (finalPID == null || finalPID == '') {
    return 0x0;
  } else {
    return int.tryParse(finalPID!);
  }
}
