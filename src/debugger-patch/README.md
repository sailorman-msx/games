
[English]

# This patch is to enable the openMSX-debugger_0.10 to import the map file output by z80asm. It is mainly based on macOS, but Windows is not much different.

## How-to Apply Patch

**STEP1. Install QT**

Since openMSX-debugger uses QT, you need to install QT with HomeBrew.

brew install qt5

**STEP2. Download the source code of openMSX-debugger.**

Snapshot / Source code (zip)
https://github.com/openMSX/debugger/archive/debugger-master.zip

**STEP3. Extract the source code zip.**

Extract the zip file to an appropriate directory.

mkdir -p ~/Download/openMSX-debugger
cp ~/Download/debugger-master.zip ~/openMSX-debugger/.
cd ~/openMSX-debugger
unzip debugger-master.zip 

**STEP4. raw download (or git clone) our Git patch file and overwrite the patch file to the extracted source**

cp ~/Download/SymbolManager.cpp ~/openMSX-debugger/debugger-master/src/.
cp ~/Download/SymbolTable.cpp ~/openMSX-debugger/debugger-master/src/.
cp ~/Download/SymbolTable.h ~/openMSX-debugger/debugger-master/src/.

**STEP5. build openMSX-debugger.**

cd ~/openMSX-debugger/debugger-master
make

If you have any error in make, please DM me at Twitter:@brapunch2000. We will fix it as soon as possible.

**STEP6. If build succeeds, you should have the following directory.**

ls -l ~/openMSX-debugger/debugger-master/derived/openMSX_Debugger.app

**STEP7. Start Finder and copy openMSX_Debugger.app to your application folder.**
*You can recognize openMSX_Debugger.app by the penguin icon.

## How-to MAP File usage

**STEP1. z80asm will output a map file when assembling with the following options.**

z80asm -b -m test.asm

*In this example, a source file named test.asm is assembled and a map file named test.map is output.

**STEP2. start openMSX-debugger**

**STEP3. open the symbol manager**

Select System -> Symbol Manager from the top menu of openMSX-debugger.

**STEP4. import the map file created by z80asm**

Click the Add button on the Symbol Manager dialog and select the created map file. After selecting the file, confirm that the contents of the map file are reflected in the address labels.

[Japanese]

# このパッチはopenMSX-debuggerでz80asmが出力するmapファイルを取り込めるようにするためのパッチです。主にmacOSをベースとしていますがWindowsでもさほど違いはないでしょう。

## パッチを適用してopenMSX-debuggerをビルドする

**STEP1. QTをインストールする**

openMSX-debuggerはQTを使っていますので、QTをHomeBrewでインストールする必要があります。QTをすでにインストール済みであればこの手順はスキップしてください。

brew install qt5

**STEP2.openMSX-debuggerのソースコードをダウンロードする。**

Snapshot / Source code (zip)
https://github.com/openMSX/debugger/archive/debugger-master.zip

**STEP3.ソースコードのzipを展開する**

適当なディレクトリにダウンロードしたzipを展開します。

mkdir -p ~/Download/openMSX-debugger
cp ~/Download/debugger-master.zip ~/openMSX-debugger/.
cd ~/openMSX-debugger
unzip debugger-master.zip 

**STEP4. 当Gitのパッチファイルをrawダウンロード（もしくはgit clone）してパッチファイルを展開後のソースに上書きしてください**
。

cp ~/Download/SymbolManager.cpp ~/openMSX-debugger/debugger-master/src/.
cp ~/Download/SymbolTable.cpp ~/openMSX-debugger/debugger-master/src/.
cp ~/Download/SymbolTable.h ~/openMSX-debugger/debugger-master/src/.

**STEP5. openMSX-debuggerをビルドします。**

cd ~/openMSX-debugger/debugger-master
make

*makeでエラーが出た場合はTwitter:@brapunch2000までDMをください。できるだけ早めに対処します。

**STEP6. ビルドに成功すると以下のディレクトリが出来上がるはずです。**

ls -l ~/openMSX-debugger/debugger-master/derived/openMSX_Debugger.app

**STEP7. Finderを起動し、openMSX_Debugger.appをアプリケーションフォルダにコピーしてください。**

*openMSX_Debugger.appはペンギンアイコンで表示されるのでわかります。

## OpenMSX-debuggerでmapファイルを使う

**STEP1. z80asmでは以下のようなオプションをつけるとアセンブル時にmapファイルを出力します。**

z80asm -b -m test.asm

*この例では test.asm というアセンブリコードが書かれたソースファイルをアセンブルして、test.map というmapファイルが出力されます。

**STEP2. openMSX-debuggerを起動する**

**STEP3. シンボルマネージャーを開く**

openMSX-debuggerの上メニューから System -> Symbol Manager を選択します。

**STEP4. z80asmで作成されたmapファイルを取り込む**

Symbol Managerダイアログの Add ボタンをクリックして、作成されたmapファイルを選択してください。選択後、Address labelsにmapファイルの内容が反映されたことを確認してください。

