import 'dart:io';

Future<void> writeSourcePath(String sourcePath) async {
  if(getSourceTxtPath().isEmpty){return;}
  File file = File(getSourceTxtPath());
  if(!file.existsSync()){
    file.create();
  }
  await file.writeAsString(sourcePath,mode: FileMode.write);
}

Future<void> writeOutputPath(String outputPath) async {
  if(getOutputTxtPath().isEmpty){return;}
  File file = File(getOutputTxtPath());
  if(!file.existsSync()){
    file.create();
  }
  await file.writeAsString(outputPath,mode: FileMode.write);
}

String commonPrefix = '';
void setCommonPrefix(String rootPrefix){
  commonPrefix = rootPrefix;
}
String getCommonTxtPath(){
  String commonPath = commonPrefix + '\\fonttool\\';

  if(Platform.isWindows){
    commonPath += 'windows\\';
  }else if(Platform.isMacOS){
    commonPath += 'macos\\';
  }else if(Platform.isLinux){
    commonPath += 'linux\\';
  }else {
    return '';
  }
  return commonPath;
}
//返回记录路径的txt文件路径
String getSourceTxtPath(){
  if(getCommonTxtPath().isEmpty){
    return '';
  }
  String sourceTxtPath = getCommonTxtPath() + 'config\\sourcePath.txt';
  return sourceTxtPath;
}
String getOutputTxtPath(){
  if(getCommonTxtPath().isEmpty){
    return '';
  }
  String outputTxtPath = getCommonTxtPath() + 'config\\outputPath.txt';
  return outputTxtPath;
}
String getFontTxtPath(){
  if(getCommonTxtPath().isEmpty){
    return '';
  }
  String fontTxtPath = getCommonTxtPath() + 'config\\fontcontent.txt';
  return fontTxtPath;
}
//返回可执行应用程序的路径
String getApplicationPath(){
  String applicationPath = getCommonTxtPath();
  if(Platform.isWindows){
    applicationPath += 'fonttool.exe';
  }else if(Platform.isMacOS){
    applicationPath += 'fonttool.bmg';
  }else if(Platform.isLinux){
    applicationPath += 'fonttool.elf';
  }else {
    return '';
  }
  return applicationPath;
}