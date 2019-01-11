#!/bin/sh
echo "Compiling object files"
g++ -Iciga -D MAC_OSX -c ciga/acorn.cpp -o objects/acorn.o
g++ -Iciga -D MAC_OSX -c ciga/albillo.cpp -o objects/albillo.o
g++ -Iciga -D MAC_OSX -c ciga/amaryllis.cpp -o objects/amaryllis.o
g++ -Iciga -D MAC_OSX -c ciga/amaryllis-gui.cpp -o objects/amaryllis-gui.o
g++ -Iciga -D MAC_OSX -c ciga/argillite.cpp -o objects/argillite.o
g++ -Iciga -D MAC_OSX -c ciga/abyss.cpp -o objects/abyss.o
g++ -Iciga -D MAC_OSX -c ciga/CIGData.cpp -o objects/CIGData.o
g++ -Iciga -D MAC_OSX -c ciga/MemoryBlock.cpp -o objects/MemoryBlock.o
g++ -Iciga -D MAC_OSX -c main.cpp -o objects/main.o
echo "Linking executable"
g++ -o MirthKit-OSX objects/acorn.o objects/albillo.o objects/amaryllis.o objects/amaryllis-gui.o \
objects/argillite.o objects/abyss.o objects/CIGData.o objects/MemoryBlock.o objects/main.o \
-framework OpenGL -framework AppKit -lsquirrel -lsqstdlib -lSDL -lSDLmain -lSDL_ttf -lSDL_image -lSDL_mixer -lcurl -lsqlite3 -lz -lcrypto
