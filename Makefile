jam: main.odin grid.odin player.odin editor.odin animation.odin menu.odin atlas.png
	odin build . -error-pos-style=unix -debug

atlas.png: textures
	odin run atlas-builder
