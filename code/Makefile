all: eraser.gg

eraser.gg: main.asm palettes.asm vdp.asm
	vasm -Fbin -o eraser.gg main.asm

clean:
	rm -f eraser.gg
