import 'dart:io';
import '../fileRecord/fileRecord.dart';

Future<void> collectionMain(List<String> dirPaths, List<String> filePaths) async {
  Set set = {};
  set.addAll([1,2,3,4,5,6,7,8,9,0]);
  set.addAll([
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
    'p','q','r','s','t','u','v','w','x','y','z'
  ]);
  set.addAll([
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
    'P','Q','R','S','T','U','V','W','X','Y','Z'
  ]);

  for (var dirPath in dirPaths) {
    var list = await collectDir(dirPath);
    set.addAll(list);
  }

  for (var filePath in filePaths) {
    var list = await collectFile(filePath);
    set.addAll(list);
  }

  File file = File(getFontTxtPath());
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }

  await file.writeAsString(set.join(), mode: FileMode.write);
}

Future<List> collectDir(String dirPath) async {
  Set writeSet = {};
  Directory dir = Directory(dirPath);

  // 遍历目录
  var fileList = await dir.list(recursive: true).toList();
  var fileObjList = [];
  for (var element in fileList) {
    writeSet.addAll(element.path.split(''));
    if (element is File) {
      fileObjList.add(element);
    }
  }

  // 读取文件内容（失败则跳过）
  for (var file in fileObjList) {
    try {
      var temp = await file.readAsString();
      writeSet.addAll(temp.split(''));
    } catch (e) {
      // 读不出文件直接跳过
      stderr.writeln("跳过无法读取的文件: ${file.path}  错误: $e");
      continue;
    }
  }

  return writeSet.toList();
}

Future<List> collectFile(String filePath) async {
  Set writeSet = {};
  File file = File(filePath);
  try {
    var temp = await file.readAsString();
    writeSet.addAll(temp.split(''));
  } catch (e) {
    stderr.writeln("跳过无法读取的文件: $filePath  错误: $e");
  }
  return writeSet.toList();
}