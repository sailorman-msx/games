import pyxel
import os
from pathlib import Path
import PyxelUniversalFont as puf
from enum import Enum
import svgwrite

class SPC_KEY(Enum):
    NONE       = 0
    PRESS_DOWN = 1
    PRESS_UP   = 2

class PROC_MODE(Enum):
    MODE_SELECT = 0
    MODE_EDIT   = 1

# Global variable definition
GR2PTNFILE="MSXGR2.DAT"

class App:

    def __init__(self):

        # キャラクタコードとVRAMアドレスの変数
        self.SelChar   = 0
        self.VramPtn   = 0x0000
        self.VramClr   = 0x2000
        self.ArrAdjust = 0

        # タイマー
        # ダイアログ表示時に120がセットされる
        # 60fpsでdrawが呼び出されるので2秒後にゼロになるよう
        # カウントダウンすること
        self.timer = 0

        # モード切り替えボタン押下
        # 0: 押してない
        # 1: 押した
        # 2: 押して離した(OnClick相当)
        self.KEY_SPC_Event  = SPC_KEY.NONE
        
        # Mode
        # 0 : PatternEdit Select mode
        #     文字の選択、インポート、エクスポートのみ実施できる
        # 1 : PatternEdit Edit mode
        #     キャラクタパターンとカラーパターンの編集のみ実施できる
        self.MODE = PROC_MODE.MODE_SELECT # mode
        self.MODETITLE = ["SELECT","EDIT"] # mode tile
 
        # パターンデータ格納用
        self.PtnData=[[0 for _i in range(8)] for j in range(256*3)]
        # カラーデータ格納用
        self.ClrData=[[0 for _i in range(8)] for j in range(256*3)]

        # 画面全体でのマウスカーソル位置
        self.mx = 0
        self.my = 0

        # 文字選択エリアでのマウスカーソル位置
        self.cx = 0
        self.cy = 0

        # グリッドエリアでのマウスカーソル位置
        self.gx = 0
        self.gy = 0

        # グリッドエリアでのカーソル位置から取得したスロット番号
        self.SelSlot = 0

        # カラー選択エリアでのマウスカーソル位置（選択色）
        self.fsx = 0
        self.fsy = 0
        self.bsx = 0
        self.bsy = 0
        self.SelFGC = 15 # デフォルト値はカラーコード15
        self.SelBGC = 1  # デフォルト値はカラーコード1

        # Flip対象スロットの選択状態
        self.FlipSlot = 0 # 初期値はSlot#0を選択状態にする

        # Flip対象位置でのマウスカーソル位置
        self.sly = 0

        # Copy+Past用変数
        self.CopiedChar = -1
        self.Yanked     = 0
        self.PtnYanked  = [0 for _i in range(8)]
        self.ClrYanked  = [0 for _i in range(8)]

        # SAVEボタン用変数
        self.MSXBSAVE   = 0
        self.PLAINSAVE  = 0

        # EXPORT SVGボタン用変数
        self.EXPORTSVG  = 0

        # グリッドに表示しているキャラクターのパターンIDX（配列の添字）
        self.GridChar = [0 for _i in range(4)]

        # Font
        self.WRITER=None

        # 入力ファイルの存在をチェックする

        # 存在しなければ空データ（背景色は前景色15,背景色1）のデータを作成する
        _path = "." + os.sep + GR2PTNFILE
        _pFile = Path(_path)
        if _pFile.exists() == False:
            # ファイルがない場合は
            # 上段、中段、下段のパターンとカラーのデータファイルを新規に作成する
            print("create empty data file.")
            _ptn = b"\x00"
            _clr = b"\xf1"
            _fp=open(_path, "wb")
            for _area in range(3):
                for _char in range(256):
                    for _i in range(8):
                        _fp.write(_ptn)
            for _area in range(3):
                for _char in range(256):
                    for _i in range(8):
                        _fp.write(_clr)
            _fp.close()
            print("create data file done.")
        
        # Initialize screen
        pyxel.init(416, 320, title="MSX GRAPHIC2 Editor",fps=60,quit_key=pyxel.KEY_Q,display_scale=2)

        # load resources
        pyxel.load("msxedit.pyxres")

        # load bitmap font
        self.WRITER = puf.Writer("misaki_gothic2.ttf")

        # mouse cursor off
        pyxel.mouse(False)

        # create Select Area
        pyxel.cls(0)
        self.drawSelectArea(src="FILE")

        pyxel.run(self.update, self.draw)

    def update(self):

        # タイマー発動中は何も受け付けない
        if self.timer > 0:
            return

        # データSAVE中は何も受け付けない
        if self.MSXBSAVE != 0 or self.PLAINSAVE != 0:
            return

        # マウスカーソルの位置によって選択候補となる
        # 文字のキャラクタの位置を特定する
        self.mx = int(pyxel.mouse_x / 8)
        self.my = int(pyxel.mouse_y / 8)
        
        # 文字選択モードか？
        if self.MODE == PROC_MODE.MODE_SELECT:

            # 文字選択エリアのカーソル移動
            # カーソル位置の取得と選択キャラクターコードの取得を行う
            # 選択キャラクターは編集グリッドのSlot#0に相当する（Slot#0＝左上）
            if (self.mx > 0 and self.mx < 33) and (self.my > 1 and self.my < 26):
                self.cx = self.mx - 1
                self.cy = self.my - 2
                if self.cy > 15:
                    self.ArrAdjust = 2
                elif self.cy > 7:
                    self.ArrAdjust = 1
                else:
                    self.ArrAdjust = 0
                # 文字のキャラクタを特定する
                self.SelChar = self.cx + ((self.cy*32) - (256*self.ArrAdjust))

            # マウス左ボタンクリック
            if pyxel.btn(pyxel.MOUSE_BUTTON_LEFT):
                if (self.mx > 0 and self.mx < 33) and (self.my > 1 and self.my < 26):
                    # 文字選択モードで左クリックが選択された
                    self.KEY_SPC_Event = SPC_KEY.PRESS_DOWN
                if (self.mx >= 33 and self.mx <= 39) and (self.my >= 28 and self.my <= 29):
                    # SVG EXPORTボタンが押された
                    self.EXPORTSVG = 1
                if (self.mx >= 41 and self.mx <= 47) and (self.my >= 28 and self.my <= 29):
                    # MSX BSAVEボタンが押された
                    self.MSXBSAVE = 1
                if (self.mx >= 41 and self.mx <= 47) and (self.my >= 30 and self.my <= 31):
                    # PLAIN BSAVEボタンが押された
                    self.PLAINSAVE = 1

            # Ctrl + C が押されてるか？
            if (pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_C)):

                # パターンデータとカラーデータをコピーする
                self.CopiedChar = self.SelChar
                
                # キャラクタパターンの先頭IDXを取得
                _idx = (256*self.ArrAdjust) + self.SelChar
        
                # パターンデータとカラーデータのコピー
                _ptn = self.PtnData[_idx]
                _clr = self.ClrData[_idx]
                for _i in range(8):
                    self.PtnYanked[_i] = _ptn[_i]
                    self.ClrYanked[_i] = _clr[_i]

                self.Yanked = 1

            # Ctrl + P が押されてるか？
            if (pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_P)):

                # Copyしたデータで選択している文字のデータを置換する
                self.CopiedChar = self.SelChar
                
                # キャラクタパターンの先頭IDXを取得
                _idx = (256*self.ArrAdjust) + self.SelChar
        
                # パターンデータとカラーデータのコピー
                for _i in range(8):
                    self.PtnData[_idx][_i] = self.PtnYanked[_i]
                    self.ClrData[_idx][_i] = self.ClrYanked[_i]

        else:

            # 編集モード
            # 編集モードではグリッド内のドット部と
            # 前景色、背景色を選択可能とする
            # Ctrl + F でカーソルが位置するスロットのパターンを前景色で塗りつぶす
            # Ctrl + R でカーソルが位置するスロットのパターンを0クリアする

            # グリッドカーソル位置の取得
            if (self.mx > 33 and self.mx < 50) and (self.my > 5 and self.my < 22):
                self.gx = self.mx - 34
                self.gy = self.my - 6

            # グリッドカーソルの位置からスロット番号を
            # 取得する
            self.SelSlot = 0
            if self.gx >= 8:
                if self.gy < 8:
                    self.SelSlot = 2
                else:
                    self.SelSlot = 3
            elif self.gy >= 8:
                self.SelSlot = 1

            # 前景色カーソル位置の取得
            if (self.mx > 33 and self.mx < 50) and (self.my == 23):
                self.fsx = self.mx - 34
                self.fsy = self.my - 23

            # 背景色カーソル位置の取得
            if (self.mx > 33 and self.mx < 50) and (self.my == 25):
                self.bsx = self.mx - 34
                self.bsy = self.my - 25

            # Flipカーソル位置の取得
            if (self.mx == 11) and (self.my >= 29 and self.my <= 32 ):
                self.sly = self.my - 29

            # Ctrl + F （スロット塗りつぶし）が押されたか？
            if pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_F):
                self.fillSlot()
                return

            # Ctrl + R （スロットクリア）が押されたか？
            if pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_R):
                self.removeSlot()
                return

            # Ctrl + H （H-FLIP）が押されたか？
            if pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_H):
                self.flipHorizontal()
                return

            # Ctrl + V （V-FLIP）が押されたか？
            if pyxel.btn(pyxel.KEY_CTRL) and pyxel.btn(pyxel.KEY_V):
                self.flipVertical()
                return

            # マウス左ボタンクリック
            if pyxel.btn(pyxel.MOUSE_BUTTON_LEFT):
                if (self.mx > 33 and self.mx < 50) and (self.my > 5 and self.my < 22):
                    # グリッドのドットで左クリックされた
                    # ドットをプロットする
                    self.dotPlot(proc=True)
                    return
                if (self.mx > 33 and self.mx < 50) and (self.my == 23):
                    # 前景色選択欄で左クリックされた
                    self.SelFGC = self.fsx
                if (self.mx > 33 and self.mx < 50) and (self.my == 25):
                    # 背景色選択欄で左クリックされた
                    self.SelBGC = self.bsx
                if self.mx == 11 and (self.my >= 29 and self.my <= 32):
                    # Flipのスロット番号選択欄で左クリックされた
                    self.FlipSlot = self.sly
                    self.SelSlot = self.FlipSlot
                    # スロット番号選択時にはSlotの左端にカーソルを位置付ける
                    self.gx=0
                    self.gy=0
                    if self.FlipSlot == 0:
                        self.gy=0
                    elif self.FlipSlot == 1:
                        self.gy=8
                    elif self.FlipSlot == 2:
                        self.gx=8
                    elif self.FlipSlot == 3:
                        self.gx=8
                        self.gy=8
                if (self.mx >= 11 and self.mx <= 15) and (self.my == 34):
                    # H-FLIP が押された
                    self.flipHorizontal()
                    return
                if (self.mx >= 11 and self.mx <= 15) and (self.my == 36):
                    # V-FLIP が押された
                    self.flipVertical()
                    return

            # マウス右ボタンクリック
            if pyxel.btn(pyxel.MOUSE_BUTTON_RIGHT):
                if (self.mx > 33 and self.mx < 50) and (self.my > 5 and self.my < 22):
                    # グリッドのドットで右クリックされた
                    # ドットを消去する
                    self.dotPlot(proc=False)
                    return

        # マウス左ボタンクリック
        if pyxel.btn(pyxel.MOUSE_BUTTON_LEFT):
            if (self.mx >=34 and self.mx <=41) and self.my == 1:
                # スペースキークリックを強制してモードを変更する
                self.KEY_SPC_Event = SPC_KEY.PRESS_DOWN
                return
    
        # モード切り替えが行われているかチェックする
        if pyxel.btn(pyxel.KEY_SPACE):
            if self.KEY_SPC_Event == SPC_KEY.NONE:
                self.KEY_SPC_Event = SPC_KEY.PRESS_DOWN
        else:
            # スペースが押されてない
            if self.KEY_SPC_Event == SPC_KEY.PRESS_DOWN:
                # OnClick相当
                self.KEY_SPC_Event = SPC_KEY.PRESS_UP

    def writeMSXBSAVE(self):

        # MSX BSAVE形式のファイルを出力する

        _fpath = "." + os.sep + "MSXGR2PT.BIN"
        _fp=open(_fpath, "wb")

        # パターンテーブル情報の出力

        # ヘッダ出力:7 byte
        # FE 00 00 FF 17 00 00
        _arr = bytearray([0xfe, 0x00, 0x00, 0xff, 0x17, 0, 0])
        _header = bytes(_arr)
        _fp.write(_header)

        # パターンデータ出力
        _arr = bytearray([0 for _i in range(8)])
        for _idx in range(256*3):
            for _i in range(8):
                _arr[_i] = self.PtnData[_idx][_i]
            _8bytes = bytes(_arr)
            _fp.write(_8bytes)

        _fp.close()
      
        _fpath = "." + os.sep + "MSXGR2CL.BIN"
        _fp=open(_fpath, "wb")

        # カラーテーブル情報の出力

        # ヘッダ出力:7 byte
        # FE 00 20 FF 37 00 00
        _arr = bytearray([0xfe, 0x00, 0x20, 0xff, 0x37, 0, 0])
        _header = bytes(_arr)
        _fp.write(_header)

        # カラーデータ出力
        _arr = bytearray([0 for _i in range(8)])
        for _idx in range(256*3):
            for _i in range(8):
                _arr[_i] = self.ClrData[_idx][_i]
            _8bytes = bytes(_arr)
            _fp.write(_8bytes)

        _fp.close()
      
        # BSAVE処理の終了
        self.MSXBSAVE = 0
        self.timer = 120

    def writePLAINSAVE(self):

        # Plain Binary形式（このエディタで読める形式）のファイルを出力する

        _fpath = "." + os.sep + "MSXGR2.DAT"
        _fp=open(_fpath, "wb")

        # パターンテーブルとカラーテーブル情報の出力

        # パターンデータ出力
        _arr = bytearray([0 for _i in range(8)])
        for _idx in range(256*3):
            for _i in range(8):
                _arr[_i] = self.PtnData[_idx][_i]
            _8bytes = bytes(_arr)
            _fp.write(_8bytes)

        # カラーテーブル情報の出力
        _arr = bytearray([0 for _i in range(8)])
        for _idx in range(256*3):
            for _i in range(8):
                _arr[_i] = self.ClrData[_idx][_i]
            _8bytes = bytes(_arr)
            _fp.write(_8bytes)

        _fp.close()
      
        # Plain SAVE処理の終了
        self.PLAINSAVE = 0
        self.timer = 120

    def exportSVG(self):

        # Pyxelのカラーデータを取得する
        _clrList = [ 0 for _i in range(16) ]
        for _i in range(16):
            _clrList[_i] = pyxel.colors[_i]

        # グラフィックデータをSVG形式で出力する
        # SVGに出力する画像は1ドットあたり4px x 4pxとする
        _svgimg = svgwrite.Drawing("MSXGR2.svg", size=("%dpx" % (256*4), "%dpx" % (192*4)))

        # 文字選択エリア同等の見た目で出力する
        _arrIdx = 0
        _orgX = 0
        _orgY = 0
        for _i in range(256*3): 
            if (_i % 32 == 0 ) and _i != 0:
                _orgX = 0
                _orgY = _orgY + 8
            _y = _orgY
            # グループID(<g>タグのID)は エリア番号 - キャラクタコード とする
            _gid = 0
            if _i != 0:
                _gid = int(_i/256)
            _svgG = _svgimg.g(id="%01d-%03d" % (_gid, (_i - (256*_gid))))
            for _j in range(8):
                _ptn = self.PtnData[_arrIdx][_j]
                _clr = self.ClrData[_arrIdx][_j]
                # 前景色
                _forecolor = _clr >> 4
                # 背景色
                _backcolor = _clr & 0x0f
                _binStr="{:08b}".format(_ptn)
                # 1ラインの描画
                for _dot in range(len(_binStr)):
                    if _binStr[_dot] == "1": # bit on
                        _clrStr = "#" + "{:06X}".format(_clrList[_forecolor])
                        _rect=_svgimg.rect(insert=(_orgX+_dot*4, _y*4), size=(4, 4), fill=_clrStr)
                        _svgG.add(_rect)
                    else:
                        _clrStr = "#" + "{:06X}".format(_clrList[_backcolor])
                        _rect=_svgimg.rect(insert=(_orgX+_dot*4, _y*4), size=(4, 4), fill=_clrStr)
                        _svgG.add(_rect)
                _y += 1
            _orgX += 32
            _arrIdx += 1
            _svgimg.add(_svgG)

        # SVGファイルを出力
        _svgimg.save()

        # グラフィックデータをSVG形式で出力する
        # SVGに出力する画像は1ドットあたり4px x 4pxとする
        _svgimg = svgwrite.Drawing("MSXGR2_C.svg", size=("32px", "32px"))

        # 文字ごとに出力する
        # このSVGファイルを読み込んでも一覧はできないので注意！
        _arrIdx = 0
        for _i in range(256*3): 
            _y = 0
            # グループID(<g>タグのID)は エリア番号 - キャラクタコード とする
            _gid = 0
            if _i != 0:
                _gid = int(_i/256)
            _svgG = _svgimg.g(id="%01d-%03d" % (_gid, (_i - (256*_gid))))
            for _j in range(8):
                _ptn = self.PtnData[_arrIdx][_j]
                _clr = self.ClrData[_arrIdx][_j]
                # 前景色
                _forecolor = _clr >> 4
                # 背景色
                _backcolor = _clr & 0x0f
                _binStr="{:08b}".format(_ptn)
                # 1ラインの描画
                for _dot in range(len(_binStr)):
                    if _binStr[_dot] == "1": # bit on
                        _clrStr = "#" + "{:06X}".format(_clrList[_forecolor])
                        _rect=_svgimg.rect(insert=(_dot*4, _y*4), size=(4, 4), fill=_clrStr)
                        _svgG.add(_rect)
                    else:
                        _clrStr = "#" + "{:06X}".format(_clrList[_backcolor])
                        _rect=_svgimg.rect(insert=(_dot*4, _y*4), size=(4, 4), fill=_clrStr)
                        _svgG.add(_rect)
                _y += 1
            _arrIdx += 1
            _svgimg.add(_svgG)

        # SVGファイルを出力
        _svgimg.save()

        # タイマーセット
        self.timer = 120

        self.EXPORTSVG = 0

    def dotPlot(self,proc=None):

        # グリッドへのプロット（もしくは消去）処理
        # 引数 proc = True  : プロットする
        #             False : 消去する
        _slot = 0

        # グリッドの場所（左上、左下、右上、右下）を判定する
        if self.gx >= 8:
            _slot += 2
            _dataRowIdx = 0
        if self.gy >= 8:
            _slot += 1

        if self.gx >= 8:
            _dataColIdx = self.gx - 8
        else:
            _dataColIdx = self.gx

        if self.gy >= 8:
            _dataRowIdx = self.gy - 8
        else:
            _dataRowIdx = self.gy
        
        # キャラクタの先頭IDXを特定する
        _idx = self.GridChar[_slot]     
        if _idx == 1024:
            # 編集不可のグリッドであれば何もせずリターンする
            return

        # 編集前のパターンデータを取得する
        _ptn = self.PtnData[_idx][_dataRowIdx]
        _clr = self.ClrData[_idx][_dataRowIdx]
        
        # ビット情報を加工する
        _binStr="{:08b}".format(_ptn)
        _afterBinStr=""
        for _i in range(8):
            if _i == _dataColIdx:
                if proc == True:
                    _afterBinStr += "1" # Bit on
                else:
                    _afterBinStr += "0" # Bit off
            else:
                _afterBinStr += _binStr[_i]
        _ptn = int("0b"+_afterBinStr, 0)
        self.PtnData[_idx][_dataRowIdx] = _ptn
        
        # カラー値を4ビット左シフトすると前景色になる
        _clr=0
        _clr=self.SelFGC << 4
        # 背景色のカラー値は上記前景色を背景色でORする
        _clr=_clr | self.SelBGC
        self.ClrData[_idx][_dataRowIdx] = _clr

    def drawSelectArea(self,src=""):

        org_x = 8
        org_y = 8

        # 上段、中段、下段のパターンを作成する
        for _area in range(3):

            for _charCd in range(256):

                if src == "FILE":
                    self.createPatternData(_charCd,src,position=_area)

                # 描画開始位置の設定
                if _charCd % 32 == 0:
                    x = 8
                    org_x = x
                    y = org_y + 8
                    org_y = y
                else:
                    x = (_charCd % 32)*8 + 8
                    org_x = x
                    y = org_y

                for _i in range(8):
                    # 1バイトの内容をビットに分割する
                    _ptn = self.PtnData[256*_area + _charCd][_i]
                    _clr = self.ClrData[256*_area + _charCd][_i]
                    _binStr="{:08b}".format(_ptn)
                    # カラーデータをビット右シフトすると前景色になる
                    _foreColor=_clr >> 4
                    # カラーデータを0x00001111でANDすると背景色になる
                    _backColor=_clr & 0x0f

                    # ビットの内容をプロットする
                    for _cnt in range(len(_binStr)):
                        # 1ラインを描画する
                        if _binStr[_cnt] == "1": # bit on
                            pyxel.pset(x, y, _foreColor)
                        else:
                            pyxel.pset(x, y, _backColor)
                        x+=1
                    x=org_x
                    y+=1

    def createPatternData(self, charCd, src, position):

        # 文字列のキャラクタデータを読み込みパターンデータとカラーデータを生成する
        _fpath = "." + os.sep + GR2PTNFILE
        _fp=open(_fpath,"rb")

        # positionの指定によって
        # 上段、中段、下段の先頭にSEEKして読む
        _fp.seek( 0x800*position + charCd * 8, 0 )

        # 8バイトぶん読み込む
        _ptnBuf = bytes(8)
        _ptnBuf = _fp.read(8)
        
        _fp.seek( 0x800*position + 0x1800 + charCd * 8, 0 )

        # 8バイトぶん読み込む
        _clrBuf = bytes(8)
        _clrBuf = _fp.read(8)
        
        _fp.close()

        # パターンデータとカラーデータを初期化する
        for _i in range(8):
            self.PtnData[256*position+charCd][_i] = 0
            self.ClrData[256*position+charCd][_i] = 0

        for _cnt in range(8):
            # バッファから1バイトを取り出す
            _byte=_ptnBuf[_cnt]
            self.PtnData[256*position+charCd][_cnt] = _byte
            _byte=_clrBuf[_cnt]
            self.ClrData[256*position+charCd][_cnt] = _byte

    def plot1Chara(self,orgX,orgY,ptnData,clrData,fillSize,border=False):

        # 1文字分だけプロットする
        _plotX = orgX
        _plotY = orgY
        for _y in range(8):
            # 1ラインの情報作成
            _ptn = ptnData[_y]
            _binStr="{:08b}".format(_ptn)
            # 1ラインの前景色、背景色の作成
            _clr = clrData[_y]
            # カラーデータをビット右シフトすると前景色になる
            _foreColor=_clr >> 4
            # カラーデータを0x00001111でANDすると背景色になる
            _backColor=_clr & 0x0f
            for _x in range(8):
                if border == True:
                    if _binStr[_x] == "1": # bit on
                        # 前景色で矩形を塗りつぶす
                        pyxel.rect(_plotX+_x*fillSize-1,_plotY,fillSize-1,fillSize-1,_foreColor)
                    else:
                        # 背景色で矩形を塗りつぶす
                        pyxel.rect(_plotX+_x*fillSize-1,_plotY,fillSize-1,fillSize-1,_backColor)
                else:
                    if _binStr[_x] == "1": # bit on
                        # 前景色で矩形を塗りつぶす
                        pyxel.rect(_plotX+_x*fillSize,_plotY,fillSize,fillSize,_foreColor)
                    else:
                        # 背景色で矩形を塗りつぶす
                        pyxel.rect(_plotX+_x*fillSize,_plotY,fillSize,fillSize,_backColor)
            _plotY+=fillSize
            
    def plotCharaData(self):

        # グリッド左上#0をプロットする
        _charCd = self.SelChar
        _arrIdx = 256*self.ArrAdjust + _charCd
        self.GridChar[0] = _arrIdx # キャラクタの先頭IDXをセットする

        gridX = 34 * 8
        gridY =  6 * 8

        self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)

        # グリッド右上#2をプロットする
        _charCd = self.SelChar + 1

        # カーソル位置が31を超えていたら
        # バツ印を描画する
        gridX = 42 * 8
        gridY =  6 * 8
        if self.cx >= 31:
            pyxel.rect(gridX, gridY, 63, 63, 0)
            pyxel.line(gridX-1, gridY-1, gridX+8*8, gridY+8*8, 7)
            pyxel.line(gridX+8*8, gridY-1, gridX-1, gridY+8*8, 7)
            self.GridChar[2] = 1024 # 存在しない先頭IDXをセットする
        else:
            _arrIdx = 256*self.ArrAdjust + _charCd
            self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)
            self.GridChar[2] = _arrIdx # キャラクタの先頭IDXをセットする

        # グリッド左下#1をプロットする
        _charCd = self.SelChar + 32

        # キャラクタコードが255を超えたら別段のキャラクターを表示する
        # 文字選択欄の最下段を選択していたらバツ印のみ表示する
        gridX = 34 * 8
        gridY = 14 * 8
        if self.cy >= 23:
            pyxel.rect(gridX, gridY, 63, 63, 0)
            pyxel.line(gridX-1, gridY-1, gridX+8*8, gridY+8*8, 7)
            pyxel.line(gridX+8*8, gridY-1, gridX-1, gridY+8*8, 7)
            self.GridChar[1] = 1024 # 存在しない先頭IDXをセットする
        else:
            if _charCd > 255:
                _charCd -= 256
                _arrIdx = 256*(self.ArrAdjust+1) + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)
            else:
                _arrIdx = 256*self.ArrAdjust + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)
            self.GridChar[1] = _arrIdx # キャラクタの先頭IDXをセットする

        # グリッド右下#3をプロットする
        _charCd = self.SelChar + 33

        # キャラクタコードが255を超えたら別段のキャラクターを表示する
        # 文字選択欄の最下段を選択していたらバツ印のみ表示する
        gridX = 42 * 8
        gridY = 14 * 8
        if self.cy >= 23 or self.cx >= 31:
            pyxel.rect(gridX, gridY, 63, 63, 0)
            pyxel.line(gridX-1, gridY-1, gridX+8*8, gridY+8*8, 7)
            pyxel.line(gridX+8*8, gridY-1, gridX-1, gridY+8*8, 7)
            self.GridChar[3] = 1024 # 存在しない先頭IDXをセットする
        else:
            if _charCd > 255:
                _charCd -= 256
                _arrIdx = 256*(self.ArrAdjust+1) + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)
            else:
                _arrIdx = 256*self.ArrAdjust + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx],8,True)
            self.GridChar[3] = _arrIdx # キャラクタの先頭IDXをセットする

    def createZoomView(self):

        # グリッド左上#0をプロットする
        _charCd = self.SelChar
        _arrIdx = 256*self.ArrAdjust + _charCd
        self.GridChar[0] = _charCd | (256*self.ArrAdjust)

        gridX =  2 * 8
        gridY = 29 * 8

        self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)

        # グリッド右上#2をプロットする
        _charCd = self.SelChar + 1

        # カーソル位置が31を超えていたら
        # バツ印を描画する
        gridX =  6 * 8
        gridY = 29 * 8
        if self.cx < 31:
            _arrIdx = 256*self.ArrAdjust + _charCd
            self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)

        # グリッド左下#1をプロットする
        _charCd = self.SelChar + 32

        # キャラクタコードが255を超えたら別段のキャラクターを表示する
        # 文字選択欄の最下段を選択していたらバツ印のみ表示する
        gridX =  2 * 8
        gridY = 33 * 8
        if self.cy < 23:
            if _charCd > 255:
                _charCd -= 256
                _arrIdx = 256*(self.ArrAdjust+1) + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)
            else:
                _arrIdx = 256*self.ArrAdjust + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)

        # グリッド右下#3をプロットする
        _charCd = self.SelChar + 33

        # キャラクタコードが255を超えたら別段のキャラクターを表示する
        # 文字選択欄の最下段を選択していたらバツ印のみ表示する
        gridX =  6 * 8
        gridY = 33 * 8
        if self.cy < 23 and self.cx < 31:
            if _charCd > 255:
                _charCd -= 256
                _arrIdx = 256*(self.ArrAdjust+1) + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)
            else:
                _arrIdx = 256*self.ArrAdjust + _charCd
                self.plot1Chara(gridX, gridY, self.PtnData[_arrIdx], self.ClrData[_arrIdx], 4, False)

    def createGridData(self):

        # 選択された文字をグリッドに表示する
       
        # グリッド枠の表示
        gridX = 34 * 8
        gridY =  6 * 8
        for _y in range(0,32,2):
            for _x in range(0,32,2):
                pyxel.rectb(gridX+_x*4-1,gridY+_y*4-1,1,1,15)

        # グリッドにキャラクタデータを描画する
        self.plotCharaData()

        # グリッドの文字境界を描画する
        pyxel.rectb(gridX-1,gridY-1,16*8+1,16*8+1,15)
        pyxel.line(42*8-1,gridY-1,42*8-1,gridY+16*8-1,7) # center line
        pyxel.line(gridX-1,14*8-1,gridX+16*8-1,14*8-1,7) # center line

    def fillSlot(self):

        # グリッドカーソルが位置するスロットの
        # キャラクタパターンを前景色で塗りつぶす
        _arrIdx = self.GridChar[ self.SelSlot ]
        if _arrIdx == 1024:
            # 編集できないスロットであれば何もしない
            return

        # カラー値を4ビット左シフトすると前景色になる
        _clr=0
        _clr=self.SelFGC << 4
        # 背景色のカラー値は上記前景色を背景色でORする
        _clr=_clr | self.SelBGC

        # キャラクタパターンを全部0xFFに変更する
        for _i in range(8):
            self.PtnData[_arrIdx][_i] = 0xff
            self.ClrData[_arrIdx][_i] = _clr
        
        # タイマーのセット
        self.timer = 30

    def removeSlot(self):

        # グリッドカーソルが位置するスロットの
        # キャラクタパターンをクリアする
        _arrIdx = self.GridChar[ self.SelSlot ]
        if _arrIdx == 1024:
            # 編集できないスロットであれば何もしない
            return

        # キャラクタパターンを全部0x00に変更する
        for _i in range(8):
            self.PtnData[_arrIdx][_i] = 0x00
        
        # タイマーのセット
        self.timer = 30

    def flipHorizontal(self):

        # 選択されているスロットのパターンを
        # 縦から4ドット目を境界にして
        # 水平反転させる
        # ※カラーは変更しない

        _arrIdx = self.GridChar[ self.SelSlot ]
        if _arrIdx == 1024:
            # 編集できないスロットであれば何もしない
            return

        _chgPtn = [0 for _i in range(8)]
        for _i in range(8):
            _chgPtn[_i] = self.PtnData[_arrIdx][_i]
        _chgPtn.reverse()
        for _i in range(8):
            self.PtnData[_arrIdx][_i] = _chgPtn[_i]

        # タイマーのセット
        self.timer = 30

    def flipVertical(self):

        # 選択されているスロットのパターンを
        # 横から4ドット目を境界にして
        # 垂直反転させる
        # ※カラーは変更しない

        _arrIdx = self.GridChar[ self.SelSlot ]
        if _arrIdx == 1024:
            # 編集できないスロットであれば何もしない
            return

        _chgPtn = [0 for _i in range(8)]
        for _i in range(8):
            _chgPtn[_i] = self.PtnData[_arrIdx][_i]

        for _i in range(8):
            # キャクタパターンをビットに変換する
            _binStr="{:08b}".format(_chgPtn[_i])
            _rev = _binStr[::-1]
            self.PtnData[_arrIdx][_i] = int("0b"+_rev, 0)

        # タイマーのセット
        self.timer = 30

    def putLabelArea(self, x, y, w, h, msg):

        # ラベルの枠を表示する
        pyxel.rect(x*8,y*8,w*8,h*8,0)
        pyxel.rectb(x*8-1,y*8-1,w*8+2,h*8+2,15)

        # ラベル枠の左上隅
        pyxel.blt(x*8-1,y*8-1,0,8,0,8,8)
        # ラベル枠の右上隅
        pyxel.blt((x+w-1)*8+1,y*8-1,0,16,0,8,8)
        # ラベル枠の左下隅
        pyxel.blt(x*8-1,(y+h-1)*8+1,0,24,0,8,8)
        # ラベル枠の右下隅
        pyxel.blt((x+w-1)*8+1,(y+h-1)*8+1,0,32,0,8,8)
        
        # ラベルに文字列を表示する
        self.putMsg(x+1, y+1, 0, 0, 15, msg)

    def putMsg(self,x,y,adjust_x,adjust_y,c,msg,):

        # 指定した位置にメッセージを表示する
        # 引数:
        #           x = X座標（単位:8px）
        #           y = Y座標（単位:8px）
        #    adjust_x = X座標の補正値
        #    adjust_y = Y座標の補正値
        #           c = 文字色
        self.WRITER.draw(x*8+adjust_x, y*8+adjust_y, msg, 8, c)

    def draw(self):

        # SAVE処理が実行されていればダイアログを表示する
        if self.MSXBSAVE == 1:
            # ダイアログの表示
            _msg = "Data save now. [MSX BSAVE]"
            self.putLabelArea(17,10,15,3,_msg)
            self.writeMSXBSAVE()
            return

        if self.PLAINSAVE == 1:
            # ダイアログの表示
            _msg = "Data save now. [PLAIN SAVE]"
            self.putLabelArea(17,10,15,3,_msg)
            self.writePLAINSAVE()
            return

        # EXPORT SVG処理が実行されていればダイアログを表示する
        if self.EXPORTSVG == 1:
            # ダイアログの表示
            _msg = "Export Image SVG file."
            self.putLabelArea(17,10,15,3,_msg)
            self.exportSVG()
            return

        # タイマー値がセットされていたらデクリメントする
        # 0になったら通常処理を行う
        # 0になるまでは描画処理は行なわない
        if self.timer > 0:
            self.timer -= 1
            return

        # モード切り替えボタンが押されているか？
        if self.KEY_SPC_Event == SPC_KEY.PRESS_UP:
            if self.MODE == PROC_MODE.MODE_SELECT:
                # 編集モードに切り替える
                self.MODE = PROC_MODE.MODE_EDIT
                _msg = "Change to the EDIT mode."
            elif self.MODE == PROC_MODE.MODE_EDIT:
                # 文字選択モードに切り替える
                self.MODE = PROC_MODE.MODE_SELECT
                _msg = "Change to the SELECT mode."
            self.KEY_SPC_Event = SPC_KEY.NONE
            # ダイアログを表示して2秒sleep
            self.putLabelArea(17,10,15,3,_msg)
            # Waitタイマーに値をセットする
            self.timer = 60
            return

        # Copy(Ctrl+C)が行われたか
        if self.Yanked != 0 and self.CopiedChar != -1:
            _msg = "Character copied."
            # ダイアログを表示して2秒sleep
            self.putLabelArea(17,10,15,3,_msg)
            # Waitタイマーに値をセットする
            self.timer = 60
            self.Yanked = 0
            return

        # 全画面を消去
        pyxel.cls(0)

        # 文字選択エリア下のメニュー欄を描画する
        self.putLabelArea(1,27,48,11,"")

        # Zoom viewを描画する
        self.putMsg(2,28,0,-2,15,"Zoom View")
        self.createZoomView()

        # Flip Slot選択エリアとFlip実行ボタンを描画する
        # 文字選択モードではグレーアウト表示する
        if self.MODE == PROC_MODE.MODE_SELECT:
            _clr = 17
        else:
            _clr = 15
        self.putMsg(11,28,0,-2,_clr,"Sel Slot#")
        for _i in range(4):
            self.putMsg(12,29+_i,4,0,_clr,"Slot#"+str(_i))
            if self.SelSlot == _i:
                # 選択状態として表示
                pyxel.rect(11*8,(29+_i)*8+1,8,6,_clr) # Slot#0
            else:
                # 非選択状態として表示
                pyxel.rectb(11*8,(29+_i)*8+1,8,6,_clr) # Slot#0

        # Flipボタン(H-FLIP)の表示
        pyxel.rect(11*8,33*8+4,40,14,13)
        self.putMsg(11,33,8,7,_clr,"H-FLIP")

        # Flipボタン(V-FLIP)の表示
        pyxel.rect(11*8,35*8+4,40,14,13)
        self.putMsg(11,35,8,7,_clr,"V-FLIP")

        # 文字選択エリアを描画する
        self.drawSelectArea()

        # グリッドを描画する
        self.createGridData()

        # create mode display area
        pyxel.rect(34*8,8,64,12,12+self.MODE.value)
        pyxel.rectb(34*8-1,7,65,13,15)
        _str="MODE : " + self.MODETITLE[self.MODE.value]
        self.WRITER.draw(34*8+4, 10, _str, 8, 15)

        # create character code area
        _str="0x" + "{:02X}".format(self.SelChar)+"("+format(self.SelChar)+")"
        self.WRITER.draw(274,   24, "CHARACTER:", 8, 15)
        self.WRITER.draw(274+40,24, _str, 8, 7)

        # create vram address area
        self.VramPtn = 0x0000 + (0x800 * self.ArrAdjust) + self.SelChar*8
        self.VramClr = 0x2000 + (0x800 * self.ArrAdjust) + self.SelChar*8
        _str="0x" + "{:04X}".format(self.VramPtn)
        self.WRITER.draw(274,   32, "VRAM PTN :", 8, 15)
        self.WRITER.draw(274+40,32, _str, 8, 7)
        _str="0x" + "{:04X}".format(self.VramClr)
        self.WRITER.draw(274,   40, "VRAM COL :", 8, 15)
        self.WRITER.draw(274+40,40, _str, 8, 7)

        # create color area
        self.WRITER.draw(34*8, 22*8, "Fore Color", 8, 15)
        self.WRITER.draw(34*8, 24*8, "Back Color", 8, 15)

        # 前景色選択エリアの表示
        _clrSelX = 34*8
        _clrSelY = 23*8
        for _x in range(16):
            pyxel.rect(_clrSelX+_x*8+1,_clrSelY+1, 6, 6, _x)
        for _x in range(16):
            pyxel.rect(_clrSelX+_x*8+1,_clrSelY+1, 6, 6, _x)

        # 選択されている前景色に印をつける
        _rnd = pyxel.rndi(2, 15)
        pyxel.rectb((34+self.SelFGC)*8,_clrSelY,8,8,_rnd)
       
        # 背景色選択エリアの表示
        _clrSelY = 25*8
        for _x in range(16):
            pyxel.rect(_clrSelX+_x*8+1,_clrSelY+1, 6, 6, _x)
        for _x in range(16):
            pyxel.rect(_clrSelX+_x*8+1,_clrSelY+1, 6, 6, _x)

        # 選択されている背景色に印をつける
        _rnd = pyxel.rndi(2, 15)
        pyxel.rectb((34+self.SelBGC)*8,_clrSelY,8,8,_rnd)
       
        self.mx = int(pyxel.mouse_x / 8)
        self.my = int(pyxel.mouse_y / 8)

        # 選択文字の箇所に水色で枠を表示する
        _rnd = pyxel.rndi(2, 15)
        pyxel.rectb((self.cx+1)*8, (self.cy+2)*8, 8, 8, _rnd)

        # グリッド
        # 選択された前景色で矩形に塗りつぶして表示する
        # この表示は編集モードだけ実施する
        if self.MODE == PROC_MODE.MODE_EDIT:
            _rnd = pyxel.rndi(2, 15)
            pyxel.rect((34+self.gx)*8,(6+self.gy)*8, 8, 8, self.SelFGC)
            pyxel.rectb((34+self.gx)*8, (6+self.gy)*8, 8, 8, _rnd)

        # ファイル操作関連ボタンの表示
        # ファイル操作関連ボタンは文字選択モードでのみ有効とする
        if self.MODE != PROC_MODE.MODE_SELECT:
            _clr = 17 # 無効時の表示色はグレー
        else:
            _clr = 15 # 有効時の表示色は白

        # EXPORT SVGボタン ラベルの表示
        pyxel.rect(33*8,28*8,7*8,2*8,5)
        _msg=" SVG EXPORT"
        self.putMsg(34,29,-2,-4,_clr,_msg)

        # BSAVEボタン ラベルの表示
        pyxel.rect(41*8,28*8,7*8,2*8,5)
        _msg=" MSX BSAVE"
        self.putMsg(42,29,-2,-4,_clr,_msg)

        # Plain SAVEボタン ラベルの表示
        pyxel.rect(41*8,30*8+4,7*8,2*8,5)
        _msg="Plain SAVE"
        self.putMsg(42,31,0,0,_clr,_msg)

        # タイトルロゴ表示（こんなの要らない）
        pyxel.blt(43*8,34*8,0,0,16,40,24)

        # マウスカーソルを移動させる
        _str="CURSOR POS -> " + "{:> 3}".format(self.mx) + "," + "{:> 3}".format(self.my)
        _str+=" GRID SLOT -> #" + format(self.SelSlot)
        self.WRITER.draw(2, 2, _str, 8, 7)
        pyxel.blt(pyxel.mouse_x, pyxel.mouse_y, 0, 0, 0, 8, 8)

# Main process
App()
