SMODS.Atlas
{
	key = 'Jokers',
	path = 'Jokers.png',
	px = 71,
	py = 95
}

SMODS.Atlas
{
	key = 'Decks',
	path = 'Decks.png',
	px = 71,
	py = 95
}

SMODS.Atlas
{
	key = 'Vouchers',
	path = 'Vouchers.png',
	px = 71,
	py = 95
}








--Buckshot sounds--

SMODS.Sound
{
	key = 'live',
	path = 'deal_gunshot_live.ogg'
}

SMODS.Sound
{
	key = 'blank',
	path = 'deal_gunshot_blank.ogg'
}

--Gamblecore Sound--

SMODS.Sound
{
	key = 'winning',
	path = 'deal_cantstopwinning.ogg'
}

--Medusa Sound--

SMODS.Sound
{
	key = 'hiss',
	path = 'deal_hiss.ogg'
}















assert(SMODS.load_file("./modules/vouchers.lua"))() 
assert(SMODS.load_file("./modules/jokers.lua"))() 
assert(SMODS.load_file("./modules/decks.lua"))()