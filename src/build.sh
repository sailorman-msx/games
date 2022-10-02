#!/bin/zsh
z80asm -b $1.asm
ret=$?
if [ $ret -ne 0 ]; then
   echo "error occured."
   exit 1
fi
mv $1.o   ../bin/.
mv $1.bin ../bin/.
dd bs=32k conv=sync if=../bin/$1.bin of=../bin/$1.rom
hexdump -C ../bin/$1.rom
