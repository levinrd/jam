jam: main.odin grid.odin player.odin atlas.png
	odin build . -error-pos-style=unix -debug

atlas.png: textures
	odin run atlas-builder
