===============================================================================

 MSX GRAPHIC2 Editor

 author : SAILORMAN STUDIO
      X : @brapunch2000

===============================================================================

このツールはMSXでのプログラム開発のクロス開発のためのツールです。
MSX SCREEN2 (GRAPHIC2) に対応したキャラクタパターンとカラーデータを
編集することができます。

* インストール要件

  Python3が動作する環境
  当ツールは MacbookPro (Apple M1) macOS X Sequoia 15.5 で動作検証しています

* 動作に必要なPyxelソフトウェア群のインストール方法

  ** Windows
    pip install -U pyxel
    pip install -U PyxelUniversalFont

  ** macOS X
    brew install pip3
    pip3 ensurepath
    pip3 install pyxel
    pip3 install PyxelUniversalFont

  ** Linux
    sudo pip3 install -U pyxel
    sudo pip3 install -U PyxelUniversalFont

* MSXでのSCREEN2（GRAPHIC2）モードの仕様

MSXのGRAPHIC2の仕様は文字1文字あたり横8ドットx縦8ドットです。
横8ドットで1ラインになっており
・1ラインあたり前景色が16色中の1色、背景色が16色中の1色になっています。

  （例） 文字”A"（ASCIIコード:65）の場合

         □□■□□□□□ <-- これが1ライン。全部で8ラインある。
         □■□■□□□□
         ■□□□■□□□
         ■■■■■□□□
         ■□□□■□□□
         ■□□□■□□□
         □□□□□□□□
         □□□□□□□□
         □□□□□□□□

このツールでは上記仕様に基づいて文字のパターンとカラーを編集します。

作成したデータはMSX-BASICのBSAVE形式で出力可能です。
出力データの形式は後述するデータ形式の箇所を参照ください。

* 使い方

文字選択モードと編集モードの2つのモードになっています。

** 文字選択モード

  編集したい文字を選択するモードです。
  マウスカーソルで編集した文字を選び、左クリックすると編集モードに
  移行します。
  スペースキーを押すことでも編集モードに移行できます。

  文字選択以外に以下ができます。

  Ctrl+C -- 
     選択した文字をバッファにコピーします。
  Ctrl+P -- 
     バッファにコピーされたデータで選択位置の文字を置換します。
  MSX BSAVE -- 
     MSXのBLOADで読み込める形式でデータを保存します。
     ファイル名は固定です。
       MSXGR2PT.BIN : キャラクタパターンデータ
       MSXGR2CL.BIN : キャラクタカラーデータ
        (詳細はデータ形式の箇所を参照)

     【上書きする、しないの確認は行いませんので注意してください】

  PLAIN BSAVE -- MSXのBLOADで読み込める形式でデータを保存します。
     当ツールで読み書き可能なデータ形式でデータを保存します。
     ファイル名は固定です。
       MSXGR2.DAT   : キャラクタとカラーがひとまとまりのデータです

     【上書きする、しないの確認は行いませんので注意してください】

** 編集モード

  選択した文字を編集するモードです。
  スペースキーを押すか、グリッド上部のモード表示を左クリックすることで
  文字選択モードに移行できます。

  文字選択モードで選択した文字を基準に縦2文字x横2文字がグリッド欄に
  表示されます。
  グリッドには左上が0、左下が1、右上が2、右下が3というように
  番号が割り振られています。この番号を当ツールではスロット番号(Slot#)と
  呼称しています。
  編集グリッド内のカーソル位置で

  編集グリッドの下には前景色と背景色を選択する箇所があります。
  この前景色と背景色を選択してから編集グリッドを操作する。という流れに
  なります。

  編集グリッドでは左クリックすることで選択した箇所に前景色で
  ドットを描画します。
  右クリックでドットを消去します。（背景色になります）

  グリッド欄でのドット描画以外に以下ができます。

  Ctrl + F --
     選択してあるスロットの文字を前景色で塗りつぶします。
  Ctrl + R --
     選択してあるスロットの文字を消去します。
     （全ドットが背景色になります）
  Ctrl + H --
     選択してあるスロットが4ライン目を境界として上下に反転します。
     （水平反転：H-FLIPと呼称します）
     画面下部の H-FLIP を左クリックしても同様の処理を実施します。
  Ctrl + V --
     選択してあるスロットが横4ドット目を境界として左右に反転します。
     （垂直反転：V-FLIPと呼称します）
     画面下部の V-FLIP を左クリックしても同様の処理を実施します。

  Zoom View :

     編集中の文字列を視認しやすいよう編集グリッド全体を表示します。
  
* ツールの終了

  キーボードの Q を押下するとツールを終了します。
  終了時にはファイル保存は行われないことに注意してください。

  【ファイルを保存する、しないの確認は行いませんので注意してください】

* データファイル形式

  バイナリデータファイルです。

  [ MSX BASIC形式 ]

    -- MSXGR2PT.BIN

    先頭に以下のヘッダーバイトが付与され、後続にキャラクタパターンデータが
    1パターン8バイト x 256文字 x 3エリア分（6144バイト）連続して出力されます。

      ヘッダーバイト: FE 00 00 FF 07 00 00 
      パターンデータ: 6144バイト

    トータルでファイルサイズは 6151バイトになります

    -- MSXGR2CL.BIN

    先頭に以下のヘッダーバイトが付与され、後続にカラーデータが
    1パターン8バイト x 256文字 * 3エリア分（6144バイト）連続して出力されます。

      ヘッダーバイト: FE 00 20 FF 37 00 00 
      パターンデータ: 6144バイト

    トータルでファイルサイズは 6151バイトになります

    【MSXでのパターンネームテーブルは出力しませんのでご注意ください】

  [ Plain形式 ]

    -- MSXGR2.DAT

    先頭6144バイトにキャラクターパターンデータ
    その後にカラーデータ6144バイトがつながって1ファイルになっています。

    トータルでファイルサイズは12288バイトになります

    MSXGR2.DAT.org というファイル名は初期データとして使用してください。

      cp MSXGR2.DAT.org MSXGR2.DAT  <--- これでデータを初期化できます

* データの消去

  MSXGR2.DATを削除すると、空のパターンでファイルを作成しなおして
  ツールが動作します。

* このツールの作成の経緯

  MSXのパターンエディタはおそらく世界中で何万人もの先駆者が
  作成したかと思います。
  ですが、先駆者が作成したツールのほとんどが

    MSXでしか動作しない
    Windwosでしか動作しない（macOSで動いて欲しい）
    Webで動作するが機能がリッチすぎる
    TKInterで動作するが機能がリッチすぎる

  という感じのものばかりで自分が本当に欲しいものがありませんでした。
  MSX自体が40年前のテクノロジーのものであり
  「どうせ誰も作らないだろうから・・」ということで
  自分で作ることにしました。

  Pygameなどを試しましたがしっくりこず
  結局、Pyxelで作るのがいちばん楽ちんでした。

  このツールはちょっと改造すれば、MSX2版にもなるし
  Pyxelのパターンエディター拡張にもなるんじゃないかな。と思います。
  なにより、Pyxel（というかPython）の勉強題材としても良いかなと。
  ＊作者のPythonコーディングはスクリプトレベルですが・・

* 謝辞

  当ツールは @kitao様により開発されたPyxelベースで作成してあります。
  Pyxelはこちらを参照ください。
      https://github.com/kitao/pyxel

  またフォント表示には Naoki Kobayashi様により開発された
  PyxelUniversalFontを使っています。
  PyxelUniversalFontはこちらを参照ください。
      https://github.com/n-koba0427/PyxelUniversalFont

  みなさまのツールで当ツールが動作することができました。
  ありがとうございます！

  我が家の愛猫（福ちゃん）もデータ化してます。
  可愛いから見て見て！！
    cp MSXGR2.DAT.fuku MSXGR2.DAT


[English]

===============================================================================
 MSX GRAPHIC2 Editor

 Author: SAILORMAN STUDIO
 X     : @brapunch2000
===============================================================================

This is a cross-development tool for creating graphics on the MSX.
It lets you design character patterns and colors for SCREEN 2 (GRAPHIC 2) mode.

* Requirements
  * Python 3
  * Tested on MacBook Pro (Apple M1) with macOS Sequoia 15.5

* Installing the required Pyxel libraries

  **Windows**
    pip install -U pyxel
    pip install -U PyxelUniversalFont

  **macOS**
    brew install pip3
    pip3 ensurepath
    pip3 install pyxel
    pip3 install PyxelUniversalFont

  **Linux**
    sudo pip3 install -U pyxel
    sudo pip3 install -U PyxelUniversalFont

* MSX SCREEN 2 (GRAPHIC 2) basics

Each character is an 8x8 pixel tile. Every horizontal line within the tile
uses one foreground color and one background color (out of 16 possible colors).

  Example: the letter "A" (ASCII 65)

         ..#.....
         .#.#....
         #...#...
         #####...
         #...#...
         #...#...
         ........
         ........

This editor lets you draw patterns and set colors exactly the way the MSX expects.

Files can be saved in MSX-BASIC BSAVE format (details at the end).

* How to use

There are two modes: Character Selection and Edit Mode.

** Character Selection Mode
  * Click a character or press Space to enter Edit Mode.

  Shortcuts:
    Ctrl + C  -> copy current character to clipboard
    Ctrl + P  -> paste clipboard onto current character
    MSX BSAVE -> save two files that can be BLOADed on a real MSX
                MSXGR2PT.BIN  (pattern data)
                MSXGR2CL.BIN  (color data)
    PLAIN BSAVE -> save a single file this editor can open again
                  MSXGR2.DAT (patterns + colors)

    Warning: Files are overwritten without asking!

** Edit Mode
  * The selected character is shown as four 8x8 tiles arranged in a 2x2 grid.
  * Slots are numbered 0-3 (0 = top-left, 1 = bottom-left, etc.).
  * Pick your foreground and background colors first, then start drawing.

  Drawing:
    Left-click  -> place foreground pixel
    Right-click -> erase (set to background)

  Shortcuts:
    Ctrl + F  -> fill current slot with foreground color
    Ctrl + R  -> clear current slot (all background)
    Ctrl + H  -> horizontal flip (also click the "H-FLIP" button)
    Ctrl + V  -> vertical flip   (also click the "V-FLIP" button)

  Zoom View: enlarges the whole grid so you can see the character clearly.

* Quitting
  Press Q. Nothing is saved automatically - remember to save first!

* File formats (all binary)

  [MSX BSAVE format]
    MSXGR2PT.BIN  - patterns
      Header: FE 00 00 FF 07 00 00
      Data  : 6144 bytes (8 bytes x 256 chars x 3 banks)
      Size  : 6151 bytes

    MSXGR2CL.BIN  - colors
      Header: FE 00 20 FF 37 00 00
      Data  : 6144 bytes (8 byte x 256 chars x 3 banks)
      Size  : 6151 bytes

    (Pattern Name Table is not exported.)

  [Plain format - for this editor only]
    MSXGR2.DAT
      6144 bytes patterns + 6144 bytes colors (colors repeated 8x for alignment)
      Total: 12288 bytes

    To start from the default set:
      cp MSXGR2.DAT.org MSXGR2.DAT

* Clearing Data

Deleting MSXGR2.DAT makes the tool recreate a fresh file filled 
with blank patterns and keep running.

* Why I built this

There are tons of MSX tile editors out there, but every one I tried had a catch:
  * runs only on a real MSX
  * Windows-only
  * web-based and way too heavy
  * Tkinter-based and bloated

None of them were simple, cross-platform, and just right for me.
Since the MSX is 40-year-old tech, I figured no one else would bother,
so I made exactly what I wanted.

I tried Pygame and a few other libraries, but Pyxel felt perfect and was a joy to use.

With a few tweaks this could become an MSX2 editor or even a Pyxel extension.
It was also a great way to practice Python!

* Thanks

This editor is built on Pyxel by @kitao
https://github.com/kitao/pyxel

Text display uses PyxelUniversalFont by Naoki Kobayashi
https://github.com/n-koba0427/PyxelUniversalFont

Huge thanks to both of you!

P.S. I turned our family cat Fuku-chan into tiles :)
She's adorable - load her with:
  cp MSXGR2.DAT.fuku MSXGR2.DAT

