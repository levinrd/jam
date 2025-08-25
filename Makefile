jam: main.odin grid.odin player.odin
	odin build . -error-pos-style=unix -debug

atlas.png: textures
	odin run atlas-builder
