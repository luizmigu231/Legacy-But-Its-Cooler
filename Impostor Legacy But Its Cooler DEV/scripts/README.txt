Sistema de configurações para Impostor Legacy But Its Cooler.

O plugin lê content/Impostor Legacy But Its Cooler/settings.json e storage/config.json.

Skins altera somente PlayState.SONG.player2.
Backlit altera somente PlayState.SONG.stage.

A configuração é escolhida pelo ID da música.

Exemplo para Defeat:

"defeat": {
	"opponent": {
		"Normal": "black",
		"Skin": "blackold"
	},
	"stage": {
		"On": "defeat",
		"Off": "defeat_nobacklit"
	}
}

IMPORTANTE: o plugin precisa estar em scripts/plugins/ dentro do mod, seguindo a estrutura de plugins do Legacy.
