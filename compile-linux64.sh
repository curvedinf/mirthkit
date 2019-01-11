#!/bin/sh
echo "Compiling object files"
g++ -Iciga -D LINUX_32 -c ciga/acorn.cpp -o objects/acorn.o
g++ -Iciga -D LINUX_32 -c ciga/albillo.cpp -o objects/albillo.o
g++ -Iciga -D LINUX_32 -c ciga/amaryllis.cpp -o objects/amaryllis.o
g++ -Iciga -D LINUX_32 -c ciga/amaryllis-gui.cpp -o objects/amaryllis-gui.o
g++ -Iciga -D LINUX_32 -c ciga/argillite.cpp -o objects/argillite.o
g++ -Iciga -D LINUX_32 -c ciga/abyss.cpp -o objects/abyss.o
g++ -Iciga -D LINUX_32 -c ciga/CIGData.cpp -o objects/CIGData.o
g++ -Iciga -D LINUX_32 -c ciga/MemoryBlock.cpp -o objects/MemoryBlock.o
g++ -Iciga -D LINUX_32 -D _SQ64 -c main.cpp -o objects/main.o
echo "Linking executable"
g++ -g -rdynamic -o mirthkit.64 objects/acorn.o objects/albillo.o objects/amaryllis.o objects/amaryllis-gui.o \
objects/argillite.o objects/abyss.o objects/CIGData.o objects/MemoryBlock.o objects/main.o \
-lsquirrel3 -lsqstdlib3 -lSDL -lSDL_ttf -lSDL_image -lSDL_mixer -lcurl -lGL -lsqlite3 -lssl \
-lcrypto -lz
