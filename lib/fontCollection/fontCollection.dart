import 'dart:io';

import '../fileRecord/fileRecord.dart';

Future<void> collectionMain(List<String> dirPaths, List<String> filePaths) async {
  Set set = {};
  set.addAll([1,2,3,4,5,6,7,8,9,0]);
  set.addAll(['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']);
  set.addAll(['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);

  for(var dirPath in dirPaths){
    var list = await collectDir(dirPath);
    set.addAll(list);
  }

  for(var filePath in filePaths){
    var list = await collectFile(filePath);
    set.addAll(list);
  }

  File file = File(getFontTxtPath());
  if(!file.existsSync()){
    file.create();
  }

  await file.writeAsString(set.join(),mode: FileMode.write);
}
Future<List> collectDir(String dirPath) async {
  Set writeSet = {};
  // writeSet.addAll([1,'d',5]);
  // print(writeSet);

  //1. create rootDir (assets\\write)
  Directory dir = Directory(dirPath);

  //2. search the recursive children dir/file names of rootDir
  var fileList = await dir.list(recursive: true).toList();
  var FileList = [];
  fileList.forEach((element) {
    writeSet.addAll(element.path.split(''));
    if(element.runtimeType.toString() == '_File'){
      //print(element.toString());
      FileList.add(element);
    }
  });

  //read the content of files
  for(var i=0; i<FileList.length; i++){
    File file = File(FileList[i].path);
    var temp = await file.readAsString();
    writeSet.addAll(temp.split(''));
  }

  //print(writeSet.toList());
  return writeSet.toList();
}

Future<List> collectFile(String filePath) async {
  Set writeSet = {};
  File file = File(filePath);
  var temp = await file.readAsString();
  writeSet.addAll(temp.split(''));
  return writeSet.toList();
}