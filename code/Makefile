all: game.gg

game.gg: main.asm palettes.asm vdp.asm
	vasm -Fbin -o game.gg intro_template.asm

clean:
	rm -f game.gg
