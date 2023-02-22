return {
	ID = 1,
	Name = "Snake",
	Type = {
		"Wild", "Animal"
	},
	HP = 100,
	MP = 0,
	AP = 1,
	Resources = {
		"snake.png"
	},
	BaseDMGMIN = 1,
	BaseDMGMAX = 5,
	DMGElements = {
		"Poison"
	},
	Drop = {
		Enabled = true,
		GoldMIN = 0,
		GoldMAX = 5,

		EXPMIN = 1,
		EXPMAX = 5,

		Items = {
			DropOnlyOneItem = true,
			ItemsData = {
				{ Name = "meat",          Chance = 60, Type = "item" },
				{ Name = "bones",         Chance = 50, Type = "item" },
				{ Name = "animalLeather", Chance = 20, Type = "item" },
				{ Name = "woodenSword",   Chance = 10, Type = "weapon" },
				{ Name = "snakeArmor",    Chance = 1,  Type = "armor" },
			}
		}
	}
}
