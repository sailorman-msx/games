#!python3

"""

※defb部分は次のような仕様になっている
先頭行はヘッダ部
  全体のバイト数
2行目からデータ部
  上位4ビットはタイル番号の個数
  下位4ビットはタイル番号

  
データに単独の数値が少なければ少ないほど圧縮効果が高くなる
"""
import sys

TARGETFILE = ""
SPLITREC = []
READDATA = ""
DEFBDICT_LIST = []

def parseData(rec):

    global SPLITREC
    global DEFBDICT_LIST

    _targetdata = rec

    _defbdictlist = []

    # recの文字列を1バイトずつに分解する
    SPLITREC = []
    _cnt = 0
    while True:
        if len(_targetdata) == 0:
            break
        # 先頭から1バイトを切り出す
        _dat = _targetdata[:1]
        SPLITREC.append(_dat)
        # 先頭から1バイトを除去する
        _targetdata = _targetdata[1:]
        _defbdictlist.append({})

    _tup_split = tuple(SPLITREC)

    # _tup_split の内容を DEFBDICT_LISTに格納する
    _key = ""
    _key_cnt = 0
    _defbdict = {}
    _index = 0
    for _str in _tup_split:
        # print(_str)
        if _key == "":
            # 初めて見つかった
            _key_cnt = 0
            _key = _str
        elif _key != _str:
            # 前回のKEYと異なる
            _defbdict[ _key ] = _key_cnt
            _defbdictlist[ _index ] = _defbdict
            _index += 1
            _defbdict = {}
            _key_cnt = 0
            _key = _str
        if _key == _str:
            # すでにKEYが見つかっていて、前回のKEYと同じ
            # _key_cntが15の場合は前回のKEYと異なる状態にする
            if _key_cnt == 15:
                _defbdict[ _key ] = _key_cnt
                _defbdictlist[ _index ] = _defbdict
                _index += 1
                _defbdict = {}
                _key_cnt = 0
                _key = _str
            _key_cnt += 1
            _defbdict[ _key ] = _key_cnt

    _defbdict[ _key ] = _key_cnt
    _defbdictlist[ _index ] = _defbdict

    DEFBDICT_LIST = _defbdictlist

def makeAsmDefCode():

    global DEFBDICT_LIST

    _buf = ""
    _bytenum = 0
    _buf = _buf + "defb "
    for _i in DEFBDICT_LIST:
        _elemdic = _i
        for _k in _elemdic.keys():
            _elemnum = _elemdic[ _k ]
            if _elemnum > 1:
                # 複数個ある
                _buf = _buf + "$%0X%s, " % (_elemnum, _k)
                _bytenum = _bytenum + 1
            else:
                # 単独
                _buf = _buf + "$1%s, " % ( _k )
                _bytenum = _bytenum + 1

        _buf = _buf[:-2] + ", "

    _buf = _buf[:-2] # 最後のカンマとスペースを除去

    print("; DATA LENGTH\ndefb %d ; BYTES\n; COMPRESSION DATAS\n%s" % (_bytenum, _buf))

def readFileData():
    _readbuf = ""
    with open(TARGETFILE, "r") as _fd:
        while True:
            try:
                _buf = next(_fd)
                _readbuf += _buf[:-2] # "0\n"は連結しない
            except StopIteration:
                break
    _buf = ""
    _buf = _readbuf
    print("; MAP TILE\n")
    while True:
        if len(_buf) == 0:
            break
        # 末尾の0を消す
        _buf = _buf[15:]
    print(";\n")
    parseData(_readbuf)

if __name__ == "__main__":

    TARGETFILE = sys.argv[1]
    print(TARGETFILE)
    readFileData()
    makeAsmDefCode()

