import 'dart:io';
import 'package:path/path.dart' as path;

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

String getSeperator()
{
  return path.separator;
}

String getCommonTxtPath(){
  String commonPath = commonPrefix + getSeperator() + 'fonttool' + getSeperator();

  if(Platform.isWindows){
    commonPath += 'windows' + getSeperator();
  }else if(Platform.isMacOS){
    commonPath += 'macos' + getSeperator();
  }else if(Platform.isLinux){
    commonPath += 'linux' + getSeperator();
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
  String sourceTxtPath = getCommonTxtPath() + 'config' + getSeperator() +'sourcePath.txt';
  return sourceTxtPath;
}
String getOutputTxtPath(){
  if(getCommonTxtPath().isEmpty){
    return '';
  }
  String outputTxtPath = getCommonTxtPath() + 'config' + getSeperator() +'outputPath.txt';
  return outputTxtPath;
}
String getFontTxtPath(){
  if(getCommonTxtPath().isEmpty){
    return '';
  }
  String fontTxtPath = getCommonTxtPath() + 'config' + getSeperator() +'fontcontent.txt';
  return fontTxtPath;
}
//返回可执行应用程序的路径
String getApplicationPath(){
  String applicationPath = getCommonTxtPath();
  if(Platform.isWindows){
    applicationPath += 'fonttool.exe';
  }else if(Platform.isMacOS){
    applicationPath += 'fonttool_macos';
  }else if(Platform.isLinux){
    applicationPath += 'fonttool.elf';
  }else {
    return '';
  }
  return applicationPath;
}