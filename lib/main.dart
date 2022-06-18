import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fonttools_flutter/fileRecord/fileRecord.dart';
import 'package:fonttools_flutter/fontCollection/fontCollection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

void main() {
  setCommonPrefix(path.current);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sub Font Package',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String packPath  = "";

  List<String> selectedDirPath  = [];
  List<String> selectedFilePath = [];

  String generateDirName  = "";

  List<Widget> showSelectedList(List<String> selectedNameList){
    List<Widget> list = [];
    for (var selectedName in selectedNameList) {
      list.add(
        Text(selectedName),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //选择字体包
            Column(
              children: [
                const Text(
                  '选择要被处理的原字体包/choose source font package',
                ),
                TextButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['eot','otf','fon','font','ttf','ttc','woff'],    //筛选文件类型
                      );
                      //这就用完了，下面就赋值了
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        packPath = file.path!;                  //取数据，有name，path，size等等，这就取个文件地址
                        print(packPath);
                        await writeSourcePath(packPath);
                        setState(() {                     //刷新界面显示数据,否则下面的text不更新
                          packPath;
                        });
                      }
                    },
                    child: const Text("choose File")
                ),
                Text(
                  packPath,
                ),
              ],
            ),

            //选择要读取的目录
            Column(
              children: [
                const Text('选择读取的目录'),
                TextButton(
                    onPressed: () async {
                      String? tempDirPath = await FilePicker.platform.getDirectoryPath();
                      if(tempDirPath != null){
                        selectedDirPath.add(tempDirPath);
                        setState(() {
                          selectedDirPath;
                        });
                      }
                    },
                    child: const Text("choose read Dir Path")
                ),
                ...showSelectedList(selectedDirPath),
              ],
            ),
            //选择要读取的文件
            Column(
              children: [
                const Text('选择读取的文件'),
                TextButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        PlatformFile file = result.files.first;
                        if(file.path != null){
                          String tempFilePath = file.path!;
                          selectedFilePath.add(tempFilePath);
                        }
                        setState(() {
                          selectedFilePath;
                        });
                      }
                    },
                    child: const Text("choose read File Path")
                ),
                ...showSelectedList(selectedFilePath),
              ],
            ),
            TextButton(
              onPressed: () async {
                collectionMain(selectedDirPath, selectedFilePath);
              },
              child: const Text("start collect text"),
            ),

            //选择生成目录和名字
            Column(
              children: [
                const Text(
                  '选择生成字体包的目录',
                ),
                TextButton(
                    onPressed: () async {
                      generateDirName = (await FilePicker.platform.getDirectoryPath())!;
                      if(generateDirName.isNotEmpty){
                        setState(() {
                          generateDirName;
                        });
                      }
                    },
                    child: const Text("choose generate Dir")
                ),
                Text(
                  generateDirName,
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                    onPressed: () async {
                      await writeOutputPath(generateDirName+'\\a.ttf');
                      if (await launchUrl(Uri.file(getApplicationPath()))){
                        print(Uri.file(getApplicationPath()));
                      }
                    },
                    child: const Text('开始生成/start generate')
                ),
                Text(
                  '字体生成地址'+generateDirName+'\\a.ttf',
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
