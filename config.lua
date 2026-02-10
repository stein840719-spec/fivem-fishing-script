Config = {}

Config.RodItem = "fishingrod"
Config.FishingTime = 20 -- Sekunden zwischen Fängen

-- Angelzonen
Config.Zones = {
    { coords = vector3(-1860.4996, -1241.8345, 8.6158), radius = 1.0 },
    { coords = vector3(-1862.0870, -1240.6177, 8.6158), radius = 1.0 }
}

-- Verkauf NPC
Config.SellNPC = {
    coords = vector3(-1840.6559, -1234.8119, 13.0173),
    model = "a_m_m_farmer_01"
}

-- Verkaufspreise
Config.FishPrices = {
    fish_salmon = 120,
    fish_tuna = 150,
    fish_trout = 100,
    fish_cod = 110,
    fish_catfish = 200,
    fish_herring = 80,
    fish_mackerel = 90,
    fish_shark = 600,
    fish_crab = 70,
    fish_lobster = 250
}

-- Fische
Config.Fishes = {
    {item = "fish_salmon", label = "Lachs"},
    {item = "fish_tuna", label = "Thunfisch"},
    {item = "fish_trout", label = "Forelle"},
    {item = "fish_cod", label = "Kabeljau"},
    {item = "fish_catfish", label = "Wels"},
    {item = "fish_herring", label = "Hering"},
    {item = "fish_mackerel", label = "Makrele"},
    {item = "fish_shark", label = "Hai"},
    {item = "fish_crab", label = "Krabbe"},
    {item = "fish_lobster", label = "Hummer"}
}
