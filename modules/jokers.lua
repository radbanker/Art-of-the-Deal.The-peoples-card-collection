--Atraxia--

--For every consecutive round without buying something gain .5x mult--
SMODS.Joker
{
	key = 'atrax',
	loc_txt = 
	{
		name = 'Atraxia',
		text = 
		{
			'For every consecutive {C:attention}round{} without',
			'buying something at the {C:attention}Shop{},',
			'gain {X:mult,C:white}X0.5{} Mult.',
			'{C:inactive}(Currently {}{X:mult,C:white}X#1#{}{C:inactive} Mult){}',
			'\n',
			'{C:inactive}\'Pure of Mod, Body, and Soul\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 0, y = 0},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	config = 
	{ 
		extra = 
		{
			Xmult = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.Xmult}}
	end,
	calculate = function(self,card,context)
		if context.joker_main then
			return
			{
				card = card,
				Xmult_mod = card.ability.extra.Xmult,
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
		
		if context.buying_card and not context.blueprint then
			card.ability.extra.Xmult=1
			return
			{
				message = 'Reset!',
				colour = G.C.MULT
			}
		end
		
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			card.ability.extra.Xmult=card.ability.extra.Xmult+0.5 
			return
			{
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
	end
}

--Punchcard--
SMODS.Joker
{
	key = 'punch',
	loc_txt = 
	{
		name = 'Punchcard Joker',
		text = 
		{
			'Round {C:chips}Chips{} and {C:mult}Mult{} up',
			'to nearest {C:attention}power of two{}',
			'\n',
			'{C:inactive}\'The old way to program\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 0},
	rarity = 3,
	cost = 7,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and not context.blueprint then
			local powerChips = (math.ceil((math.log(hand_chips) / math.log(2)) + .1))
			local powerMult = (math.ceil((math.log(mult) / math.log(2)) + .1))
			hand_chips = 2^powerChips
			mult = 2^powerMult
			update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
			return
			{
				sound = 'multhit2',
				delay = 1,
				message = "Rounded!",
				colour = G.C.ORANGE,
				card = card
			}
		end
	end
}


--Raining Metal--
SMODS.Joker
{
	key = 'raini',
	loc_txt = 
	{
		name = 'Raining Metal',
		text = 
		{
			'{C:green}50/50{} to give either {X:mult,C:white}X3{} Mult or {X:mult,C:white}X0.5{} Mult',
			'Triggers again for every {C:attention}Joker{} to the left of it',
			'\n',
			' {C:inactive}\'I insert the shells in an unknown order\'{} '
		}
	},
	atlas = 'Jokers',
	config =
	{
		extra =
		{
			self_pos = 1
		}
	},
	pos = {x = 4, y = 5},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	calculate = function(self, card, context)
		for i,v in ipairs(G.jokers.cards) do
			if v == card then card.ability.extra.self_pos = i; break end
		end
		if context.joker_main and context.cardarea == G.jokers then
			local allLives = true
			local allBlanks = true
			local ret = {}
			local oops = false
			for i,v in ipairs(G.jokers.cards) do
				if v.config.center.key == 'j_oops' then
					G.E_MANAGER:add_event(Event({
						func = function()
							G.jokers.cards[i]:start_dissolve({G.C.RED}, nil, 1.6)
							play_sound('deal_live')
							return true
						end
					}))
					oops = true
				end
			end
			if oops then
				return
				{
					message = 'Cheater...',
					colour = G.C.MULT
				}
			end
			local function append_extra(ret, append)
				if ret.extra then return append_extra(ret.extra, append) end
				ret.extra = append
				return ret
			end
			for i=1,card.ability.extra.self_pos do
				if pseudorandom('HandSaw') < G.GAME.probabilities.normal / 2 then
					allBlanks = false
					append_extra(ret, {
						card = card,
						Xmult_mod = 3,
						message = 'Live!',
						colour = G.C.MULT,
						sound = 'deal_live'
					})
				else
					allLives = false
					append_extra(ret, {
						card = card,
						Xmult_mod = .5,
						message = 'Blank...',
						colour = G.C.MULT,
						sound = 'deal_blank'
					})
				end
			end
			if allLives and card.ability.extra.self_pos > 2 then
				append_extra(ret, {
					card = card,
					message = 'Payout!',
					colour = G.C.GOLD,
					dollars = 5 * (card.ability.extra.self_pos - 2),
					delay = 2
				})
			end
			if allBlanks and card.ability.extra.self_pos > 2 then
				append_extra(ret, {
					card = card,
					message = 'How unfortunate...',
					colour = G.C.MULT,
					delay = 2
				})
			end
			return ret
		end
	end
}

--Jooj--
SMODS.Joker
{
	key = 'joojj',
	loc_txt = 
	{
		name = 'Jooj',
		text = 
		{
			'{C:attention}Jooj{} will {C:attention}jooj{} a random {C:attention}joker{} at start of round',
			'Subsequent {C:attention}Jooji{} sell well',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:tarot,C:white,s:0.8}JinFlux{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Jooj\''
		}
	},
	atlas = 'Jokers',
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.j_deal_joojc)
	end,
	pos = {x = 2, y = 0},
	rarity = 3,
	cost = 7,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.setting_blind and not self.getting_sliced and not context.blueprint then
			local eatable_jokers = {}
			for i,v in ipairs(G.jokers.cards) do
				if v.config.center.key ~= 'j_deal_joojj' and not v.ability.eternal and not v.getting_sliced then
					eatable_jokers[#eatable_jokers+1] = v
				end
			end
			if #eatable_jokers > 0 then
				local eaten_joker = pseudorandom_element(eatable_jokers,pseudoseed('fuckthispieceofshit'))
				G.E_MANAGER:add_event(Event({
					func = function()
                        eaten_joker:start_dissolve({G.C.RED}, nil, 1.6)
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						if pseudorandom('insertanysubseedhere') < G.GAME.probabilities.normal / 20 then
							local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_deal_joojg', 'rif')
							card:add_to_deck()
							G.jokers:emplace(card)
							card:start_materialize()
							G.GAME.joker_buffer = 0
						else
							local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_deal_joojc', 'rif')
							card:add_to_deck()
							G.jokers:emplace(card)
							card:start_materialize()
							G.GAME.joker_buffer = 0
						end
						return true
					end
				}))
			end
		end
	end
}

--Golden Jooj--
SMODS.Joker
{
	key = 'joojg',
	loc_txt = 
	{
		name = 'Golden Jooj clone',
		text = 
		{
			'{C:green}#1# in #2#{} chance to replace a normal {C:attention}Jooj{} clone',
			'{X:mult,C:white}X2{} Mult',
			'Has an extremely high {C:attention}sell value{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:tarot,C:white,s:0.8}JinFlux{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Not actually that valuable but dont tell the dealer\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 4, y = 3},
	rarity = 3,
	cost = 100,
	blueprint_compat = true,
	in_pool = function(self)
        return false
	end,
	config = 
	{
		extra =
		{
			odds = 20
		}
	},
	loc_vars = function(self,info_queue,center)
		return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return
			{
				card = card,
				Xmult_mod = 2,
				message = 'X2',
				colour = G.C.MULT
			}
		end
	end
}

--Jooj clone--
SMODS.Joker
{
	key = 'joojc',
	loc_txt = 
	{
		name = 'Jooj clone',
		text = 
		{
			'{C:mult}+4{} Mult',
			'Has a high {C:attention}sell value{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:tarot,C:white,s:0.8}JinFlux{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Clone of Jooj\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 0},
	rarity = 3,
	no_collection = true,
	cost = 20,
	blueprint_compat = true,
	in_pool = function(self)
        return false
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return
			{
				card = card,
				mult_mod = 4,
				message = '+4',
				colour = G.C.MULT
			}
		end
	end
}


















---Bootleg Legendaries---

--Bootleg Perkeo--
SMODS.Joker
{
	key = 'perky',
	loc_txt = 
	{
		name = 'Perky Joker',
		text = 
		{
			'{C:green}#1# in #2#{} chance to create a {C:tarot}Fool{} card',
			'at the end of the {C:attention}Shop{}',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:chips,C:white,s:0.8}Kitty{}{C:inactive,s:0.8} on the discord!{}'
			,
			'\n',
			'{C:inactive}\'Always happy to see you\''
		}
	},
	config =
	{
		extra =
		{
			odds = 2
		}
	},
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.c_fool)
		return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
	end,
	atlas = 'Jokers',
	pos = {x = 4, y = 1},
	cost = 4,
	blueprint_compat = true,
	calculate = function(self,card,context)
		if context.ending_shop and pseudorandom('insertanysubseedhere') < G.GAME.probabilities.normal / 2 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			local _card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_fool', 'randomassseed')
			G.consumeables:emplace(_card)
		end
	end
}

--Bootleg Trib--
SMODS.Joker
{
	key = 'trick',
	loc_txt = 
	{
		name = 'Tricky Joker',
		text = 
		{
			'{C:attention}Kings{} and {C:attention}Queens{} played this hand',
			'adds {X:mult,C:white}X0.2{} to {C:attention}Joker{}',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:chips,C:white,s:0.8}Kitty{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Does magic tricks on the weekend\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 1},
	cost = 6,
	blueprint_compat = true,
	config =
	{
		extra =
		{
			Xmult = 1
		}
	},
	calculate = function(self,card,context)
		if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 12 or context.other_card:get_id() == 13) and not context.blueprint then
			card.ability.extra.Xmult=card.ability.extra.Xmult+0.2
			return
			{
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.ORANGE
			}
		end
		
		if context.joker_main then
			return
			{
				card = card,
				Xmult_mod = card.ability.extra.Xmult,
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
		
		if context.after and not context.blueprint then
			card.ability.extra.Xmult = 1
		end
	end
}

--Bootleg Canio--
SMODS.Joker
{
	key = 'canny',
	loc_txt = 
	{
		name = 'Canny Joker',
		text = 
		{
			'Each discarded {C:attention}face{} card',
			'gives {C:money}$1{}',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:chips,C:white,s:0.8}Kitty{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Somehow makes canned soup taste better\''
		}
	},
	config =
	{
		extra =
		{
			dollars = 1
		}
	},
	cost = 6,
	atlas = 'Jokers',
	pos = {x = 0, y = 1},
	blueprint_compat = true,
	calculate = function(self,card,context)
		if context.discard and context.other_card:is_face(true) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			if context.other_card.debuff then
                return {
                    message = 'Fuck you',
                    colour = G.C.RED,
                    card = card,
                }
			else
				ease_dollars(card.ability.extra.dollars)
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = '$'..card.ability.extra.dollars, colour = G.C.GOLD})
			end
		end
	end
}

--Bootleg Yorick--
SMODS.Joker
{
	key = 'yello',
	loc_txt = 
	{
		name = 'Yellow Joker',
		text = 
		{
			'{C:mult}+1{} Mult per {C:attention}card{} discarded this round',
			'{C:inactive}(Currently {}{C:mult}+#1#{}{C:inactive} Mult){}',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:chips,C:white,s:0.8}Kitty{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'In his Yellow period\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 1},
	config = 
	{ 
		extra = 
		{
			mult = 0
		}
	},
	cost = 5,
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.mult}}
	end,
	blueprint_compat = true,
	calculate = function(self,card,context)
		if context.discard and not context.blueprint then
			card.ability.extra.mult=card.ability.extra.mult+1 
			return
			{
				message = '+1',
				colour = G.C.RED,
				delay = 0.15
			}
		end
		
		if context.joker_main then
			return
			{
				card = card,
				mult_mod = card.ability.extra.mult,
				message = '+' .. card.ability.extra.mult .. ' Mult',
				colour = G.C.MULT
			}
		end
		
		if context.end_of_round and not context.repetition and not context.individual then
			card.ability.extra.mult = 0
		end
	end
}

--Bootleg Chicot
SMODS.Joker
{
	key = 'chicj',
	loc_txt = 
	{
		name = 'Chic Joker',
		text = 
		{
			'{C:attention}Boss effect{} is disabled',
			'during the {C:attention}last hand{} of a blind',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:chips,C:white,s:0.8}Kitty{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Makes a great drag queen\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 1},
	cost = 5,
	blueprint_compat = false,
	calculate = function(self,card,context)
		if ((G.GAME.current_round.hands_left == 1 and context.after) or G.GAME.current_round.hands_left == 0 and not context.end_of_round) and G.GAME.blind.boss and not context.blueprint and not G.GAME.blind.disabled then
			G.GAME.blind:disable(self)
			return
			{
                message = 'Boss disabled!',
                colour = G.C.RED,
                card = card,
            }
		end
	end
}









---Scott Jokers---
--TNT Joker--
SMODS.Joker
{
	key = 'tntjo',
	loc_txt = 
	{
		name = 'TNT',
		text = 
		{
			'When {C:attention}sold,{}',
			'{C:attention}destroy{} selected playing cards',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:attention,C:white,s:0.8}Scott C.{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Kaboom!\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 0, y = 2},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	calculate = function(self,card,context)
		if context.selling_self and not context.blueprint then
			for i=#G.hand.highlighted, 1, -1 do
				local card = G.hand.highlighted[i]
				if card.ability.name == 'Glass Card' then 
					card:shatter()
				else
					card:start_dissolve(nil, i == #G.hand.highlighted)
				end
			end
		end
	end
}

--Construction Joker--
SMODS.Joker
{
	key = 'const',
	loc_txt = 
	{
		name = 'Construction Joker',
		text = 
		{
			'{C:attention}Stone{} cards give {C:money}$2{} when scored',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:attention,C:white,s:0.8}Scott C.{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Hard working or hardly working, who\'s to tell?\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 2},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.m_stone)
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Stone Card' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			if context.other_card.debuff then
                return 
				{
                    message = 'Fuck you',
                    colour = G.C.RED,
                    card = card,
                }
			else
				return 
				{ 
					dollars = 2,
					card = context.other_card,
				}
			end
		end
	end
}

--Sandpaper--
SMODS.Joker
{
	key = 'sandp',
	loc_txt = 
	{
		name = 'Sandpaper',
		text = 
		{
			'{C:attention}Stone{} cards get {C:attention}Foiled{}',
			'when scored',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:attention,C:white,s:0.8}Scott C.{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Smoothens even the roughest edges\''
		}
	},
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.e_foil)
		table.insert(info_queue, G.P_CENTERS.m_stone)
	end,
	atlas = 'Jokers',
	pos = {x = 2, y = 2},
	rarity = 2,
	cost = 6,
	blueprint_compat=false,
	calculate = function(self, card, context)
		if context.before and context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Stone Card' then
			context.other_card:set_edition({foil = true}, true)
		end
	end
}


--Hypergiant--
SMODS.Joker
{
	key = 'hyper',
	loc_txt = 
	{
		name = 'Hypergiant',
		text = 
		{
			'When your {C:attention}consumable{} slots are full',
			'{C:blue}blue seals{} instead level up the played hand',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:attention,C:white,s:0.8}Scott C.{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Shines brightest at the end of its life\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 2},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_SEALS.Blue)
	end,
	calculate = function(self, card, context)
		if context.deal_blue_seal_failed then
			local handindex = 1
			for i,v in ipairs(G.GAME.hands) do
				if v.handname == G.GAME.last_hand_played then
					handindex = i
				end
			end
			update_hand_text({delay = 0}, {handname = G.GAME.last_hand_played, level=G.GAME.hands[G.GAME.last_hand_played].level})
			level_up_hand(card, G.GAME.last_hand_played)
			update_hand_text({delay = 0}, {chips = 0, mult = 0, level = ''})
			card_eval_status_text(context.card,"extra",nil,nil,nil,{message = localize('k_level_up_ex'), })
		end
	end
}


--Dividends--
SMODS.Joker
{
	key = 'divid',
	loc_txt = 
	{
		name = 'Dividends',
		text = 
		{
			'{C:tarot}The Hermit{} and {C:tarot}Temperance{} give an extra',
			'flat {C:money}$5{} when used',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:attention,C:white,s:0.8}Scott C.{}{C:inactive,s:0.8} on the discord!{}'
			,
			'\n',
			'{C:inactive}\'Cha-Ching!\''
		}
	},
	atlas = 'Jokers',
	blueprint_compat = true,
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.c_temperance)
		table.insert(info_queue, G.P_CENTERS.c_hermit)
	end,
	pos = {x = 4, y = 2},
	rarity = 2,
	cost = 6,
	calculate = function(self, card, context)
		if context.using_consumeable and (context.consumeable.config.center.key == 'c_hermit' or context.consumeable.config.center.key =='c_temperance') then
			ease_dollars(5)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = '$5', colour = G.C.GOLD})
		end
	end
}
---Scott's Jokers End---



























---KoLGames' Jokers---

--Laughing Joker--
SMODS.Joker
{
	key = 'laugh',
	loc_txt = 
	{
		name = 'Laughing Joker',
		text = 
		{
			'{C:mult}+3{} Mult per {C:attention}face{} card scored',
			'{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:red,C:white,s:0.8}KoLGames{}{C:inactive,s:0.8} on the discord!{}'
			,
			'\n',
			'{C:inactive}\'What\'re you laughing at?\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 0},
	rarity = 2,
	cost = 6,
	config = 
	{
		extra = 
		{
			mult = 0
		}
	},
	blueprint_compat = true,
	loc_vars = function(self,info_queue,card)
		return {vars = {card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.scoring_hand and context.cardarea == G.play and context.individual and context.other_card:is_face() and not context.blueprint then
			card.ability.extra.mult=card.ability.extra.mult+3
			return
			{
				message = 'Upgrade!',
				juice_card = card,
                colour = G.C.ORANGE
			}
		end
		
		if context.joker_main then
			return
			{
				card = card,
				mult_mod = card.ability.extra.mult,
				message = '+' .. card.ability.extra.mult .. ' Mult',
				colour = G.C.MULT
			}
		end
	end
}

--Mimic Joker--
SMODS.Joker
{
	key = 'mimic',
	loc_txt = 
	{
		name = 'Mimic Joker',
		text = 
		{
			'Copies ability of a random',
			'compatible {C:attention}Joker{} each {C:attention}round{}',
			'{C:inactive}(Currently copying {X:attention,C:white}#1#{C:inactive}){}',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:mult,C:white,s:0.8}KoLGames{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Blueprint but gambling\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 4, y = 0},
	rarity = 2,
	cost = 8,
	blueprint_compat = true,
	config =
	{
		extra =
		{
			selectedJoker = nil,
		}
	},
	loc_vars = function(self,info_queue,card)
		if card.ability.extra.selectedJoker then
			return {vars = {localize({ type = "name_text", set = "Joker", key = card.ability.extra.selectedJoker.config.center.key })}}
		else
			return {vars = {'None'}}
		end
	end,
	calculate = function(self,card,context)
		if context.setting_blind then
			local jokerList = {}
			for i,v in ipairs(G.jokers.cards) do
				if v.ability.name ~= 'Blueprint' and v.ability.name ~= 'Brainstorm' and v.ability.name ~= 'Mimic Joker' and v.config.center.blueprint_compat then
					jokerList[#jokerList + 1] = v
				end
			end
			if #jokerList > 0 then
				card.ability.extra.selectedJoker = pseudorandom_element(jokerList,pseudoseed('fuckthispieceofshit'))
			end
		end
		local other_joker = card.ability.extra.selectedJoker
		if other_joker ~= nil then
			context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
			local copy_return = other_joker:calculate_joker(context)
			if copy_return then
				return other_joker:calculate_joker(context)
			end
		end
	end
}

--Boosting Pack--
SMODS.Joker
{
	key = 'boost',
	loc_txt = 
	{
		name = 'Boosting Pack',
		text = 
		{
			'{C:green}#1# in #2#{} chance to create a random',
			'{C:attention}modified playing card{} each hand played',
			'Card always has an {C:attention}enhancement{}',
			'{C:green}#1# in #3#{} for card to have an {C:attention}edition{}',
			'{C:green}#1# in #4#{} for card to have a {C:attention}seal{}',
			'{C:inactive,s:0.8}Art and original concept by{}',
			'{X:red,C:white,s:0.8}KolGames{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Sweet, a shiny!\''
		}
	},
	config = 
	{
		extra =
		{
			odds1 = 3,
			odds2 = 2,
			odds3 = 5
		}
	},
	loc_vars = function(self,info_queue,center)
		return 
		{
			vars =
			{
				G.GAME.probabilities.normal,
				center.ability.extra.odds1,
				center.ability.extra.odds2,
				center.ability.extra.odds3
			}
		}
	end,
	atlas = 'Jokers',
	pos = {x = 0, y = 3},
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.joker_main and pseudorandom('aaaa') < G.GAME.probabilities.normal / 3 then
			G.E_MANAGER:add_event(Event({
				func = function()
					local cardC = create_playing_card({front = pseudorandom_element(G.P_CARDS, pseudoseed('killingyou')), center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
					cardC:set_ability(G.P_CENTERS[SMODS.poll_enhancement({key = 'piss', guaranteed = true})],true)
					if pseudorandom('sdasd') < G.GAME.probabilities.normal / 2 then
						cardC:set_edition(poll_edition('pissandrotinhell',1,true,true),true)
					end
					if pseudorandom('fghdfgh') < G.GAME.probabilities.normal / 5 then
						cardC:set_seal(SMODS.poll_seal({key = 'piss', guaranteed = true}),true)
					end
					G.GAME.blind:debuff_card(cardC)
                    if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
					return true
				end
			}))
			return
			{
				message = 'Card pulled!',
				card = card,
				colour = G.C.MULT
			}
		end
	end
}

--Dunce--
SMODS.Joker
{
	key = 'dunce',
	blueprint_compat = true,
	loc_txt = 
	{
		name = 'Dunce',
		text = 
		{
			'Swaps {C:chips}Chips{} and {C:mult}Mult{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:red,C:white,s:0.8}KolGames{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Constantly mixes things up\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 0, y = 4},
	rarity = 2,
	cost = 5,
	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			local tempChips = mult
			local tempMult = hand_chips
			hand_chips = tempChips
			mult = tempMult
			update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
			return
			{
				sound = 'multhit2',
				delay = 1,
				message = "Swapped!",
				colour = G.C.ORANGE,
				card = card
			}
		end
	end
}
---KoLGames' Jokers end---














--Comedy Gold--
SMODS.Joker
{
	key = 'comed',
	loc_txt = 
	{
		name = 'Comedy Gold',
		text = 
		{
			'Gain half of all {C:attention}sell value{} of all',
			'other {C:attention}Jokers{} at end of round',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:green,C:white,s:0.8}Hat Stack{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'What\'s the deal with walking?\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 3},
	rarity = 3,
	cost = 7,
	blueprint_compat = false,
	config =
	{
		extra =
		{
			money = 0
		}
	},
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			card.ability.extra.money = 0
			for i,v in ipairs(G.jokers.cards) do
				if v ~= card then
					card.ability.extra.money = card.ability.extra.money + (v.sell_cost / 2)
				end
			end
			card.ability.extra.money = math.floor(card.ability.extra.money)
		end
	end,
	calc_dollar_bonus = function(self, card)
		if card.ability.extra.money > 0 then
			return card.ability.extra.money
		end
	end
}


--Feline Joker--
SMODS.Joker
{
	key = 'felin',
	loc_txt = 
	{
		name = 'Feline',
		text = 
		{
			'Destroy the {C:attention}highest ranked{} card',
			'in hand after each {C:attention}hand played{}',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:black,C:white,s:0.8}CROW{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\':3\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 3},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.cardarea == G.hand and context.destroy_card and not card.ability.has_destroyed_this_hand and not context.blueprint then
			local highest = nil
			for _,v in ipairs(G.hand.cards) do
				if (not highest or v:get_id() > highest:get_id()) and not v.will_destroy then highest = v end
			end
			if context.destroy_card == highest then highest.will_destroy = true card.ability.has_destroyed_this_hand = true return { remove = true } end
			elseif context.joker_main then card.ability.has_destroyed_this_hand = false
			return
			{
				message = ':3 In Progress!',
				colour = G.C.ORANGE
			}
		end
	end
}


--Reflection--
SMODS.Joker
{
	key = 'refle',
	loc_txt = 
	{
		name = 'Reflection',
		text = 
		{
			'Retrigger all played {C:attention}glass{} cards',
			'{C:inactive,s:0.8}Art and concept by{}',
			'{X:black,C:white,s:0.8}CROW{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Maybe the shards of glass you\'ll make will be worth it\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 3},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(self,info_queue,center)
		table.insert(info_queue, G.P_CENTERS.m_glass)
	end,
	calculate = function(self, card, context)
		if context.repetition and context.scoring_hand and context.cardarea == G.play and context.other_card.ability.name == 'Glass Card' then
			return 
			{
				message = localize('k_again_ex'),
				repetitions = 1,
				juice_card = card
			}
		end
	end
}
















--Red Envelope--
SMODS.Joker
{
	key = 'reden',
	blueprint_compat = false,
	loc_txt = 
	{
		name = 'Red Envelope',
		text = 
		{
			'Gives {C:money}$20{} at end of each {C:attention}boss blind{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:money,C:white,s:0.8}ProbablyAnAccount{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Happy New Year!\''
		}
	},
	atlas = 'Jokers',
	pos = {x = 4, y = 4},
	rarity = 2,
	cost = 6,
	config =
	{
		extra =
		{
			dolar = 0
		}
	},
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss and not context.blueprint then
			card.ability.extra.dolar = 20
			return
			{
				colour = G.C.GOLD,
				message = '新年快乐!'
			}
		end
		if context.ending_shop and not context.blueprint then
			card.ability.extra.dolar = 0
		end
	end,
	
	calc_dollar_bonus = function(self, card)
		if card.ability.extra.dolar > 0 then
			return card.ability.extra.dolar
		end
	end
}


--Medusa--
SMODS.Joker
{
	key = 'medus',
	blueprint_compat = true,
	loc_txt = 
	{
		name = 'Medusa',
		text = 
		{
			'Gains {C:mult}+4{} Mult when a {C:attention}face card{} is scored',
			'Then turns it into a {C:attention}stone card{}',
			'{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:purple,C:white,s:0.8}Kars{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Hisssssssssssssss\'{}'
		}
	},
	atlas = 'Jokers',
	config =
	{
		extra =
		{
			mult = 0
		}
	},
	pos = {x = 1, y = 4},
	rarity = 2,
	cost = 5,
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.scoring_hand and context.cardarea == G.play and not context.blueprint and context.individual and context.other_card:is_face(true) then
			if context.other_card.debuff then
                return 
				{
                    message = 'Fuck you',
                    colour = G.C.RED,
                    card = card,
                }
			else
				card.ability.extra.mult = card.ability.extra.mult + 4
				context.other_card:set_ability(G.P_CENTERS.m_stone, nil, true)
				local name = context.other_card.ability.effect
				context.other_card.becoming_no_rank = nil
				context.other_card.config.center.replace_base_card = nil
				return
				{
					colour = G.C.RED,
                    card = card,
					message = 'Petrified!',
					sound = 'deal_hiss'
				}
			end
		end
		if context.joker_main then
			return
			{
				mult_mod = card.ability.extra.mult,
				card = card,
				message = '+' .. card.ability.extra.mult .. ' Mult',
				colour = G.C.MULT
			}
		end
	end
}


--Sculptor--
SMODS.Joker
{
	key = 'sculp',
	loc_txt = 
	{
		name = 'Sculptor',
		text = 
		{
			'{C:attention}Stone{} cards permanently gain',
			'{C:chips}+25{} chips when {C:attention}scored{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:purple,C:white,s:0.8}Kars{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'A steady hand can refine even the roughest stone\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 4},
	rarity = 2,
	cost = 6,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Stone Card' then
			context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + 25
			return
			{
				message = 'Refined!',
				colour = G.C.CHIPS,
				card = card,
				focus = context.other_card
			}
		end
	end
}






















--Blank Joker--
SMODS.Joker
{
	key = 'blank',
	blueprint_compat = false,
	loc_txt = 
	{
		name = 'Blank Joker',
		text = 
		{
			'{C:green}#1# in #2#{} at end of round to do... {C:dark_edition}something{}',
			'{C:inactive,s:0.8}Original concept by{}',
			'{X:black,C:chips,s:0.8}Sustato{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'I mean... at least it looks shiny?\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 0, y = 5},
	rarity = 3,
	cost = 10,
	loc_vars = function(self,info_queue,center)
		return {vars = {G.GAME.probabilities.normal * center.ability.extra.odds_mult, center.ability.extra.odds}}
	end,
	set_ability = function(self, card, initial, delay_sprites) card:set_edition('e_base', true, true) end,
	config =
	{
		extra =
		{
			odds = 30,
			odds_mult = 1
		}
	},
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual then 
			if pseudorandom('insertanysubseedhere') < (G.GAME.probabilities.normal * card.ability.extra.odds_mult) / 30 or card.edition and card.edition.key == "e_negative" then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_deal_darkm', 'rif')
						card:set_edition('e_negative', true, true)
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card:start_dissolve({G.C.RED}, nil, 1.6)
						return true
					end
				}))
			else
				card.ability.extra.odds_mult = card.ability.extra.odds_mult + 1
				return
				{
					message = 'Cracks grow...',
					colour = G.C.MULT,
					card = card
				}
			end
		end
	end
}


--Dark Matter--
SMODS.Joker
{
	key = 'darkm',
	blueprint_compat = false,
	loc_txt = 
	{
		name = 'Dark Matter',
		text = 
		{
			'{C:dark_edition}+1{} Hand, {C:dark_edition}+1{} Discard',
			'{C:dark_edition}+1{} Joker slot, {C:dark_edition}+2{} Handsize',
			'{C:dark_edition}Always negative{}',
			'{C:inactive,s:0.8}Original concept by{}',
			'{X:black,C:chips,s:0.8}Sustato{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Only observable by its gravity\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 1, y = 5},
	rarity = 3,
	cost = 20,
	in_pool = function(self)
        return false
	end,
	add_to_deck = function(from_debuff)
		G.hand:change_size(2)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end,
	set_ability = function(self, card, initial, delay_sprites) card:set_edition('e_negative', true, true) end,
	calculate = function(self, card, context)

	end
}

--Gamblecore--
SMODS.Joker
{
	key = 'gambl',
	blueprint_compat = true,
	loc_txt = 
	{
		name = 'Gamblecore',
		text = 
		{
			'{C:green}#1# in #2#{} chance for each scored card',
			'to gain an {C:attention}enhancement{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:tarot,C:white,s:0.8}JinFlux{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Let\'s go gambling!\'{}'
		
		}
	},
	config =
	{
		extra =
		{
			odds = 5
		}
	},
	loc_vars = function(self,info_queue,center)
		return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
	end,
	atlas = 'Jokers',
	pos = {x = 3, y = 4},
	rarity = 2,
	cost = 5,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.scoring_hand and context.other_card and pseudorandom('insertanysubseedhere') < G.GAME.probabilities.normal / 5 then
			context.other_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({key = 'piss', guaranteed = true})], nil, true)
			return
			{
				message = 'I CAN\'T STOP WINNING!!',
				colour = G.C.GOLD,
				sound = 'deal_winning'
			}
		end
	end
}

--American Joker--
SMODS.Joker
{
	key = 'ameri',
	blueprint_compat = true,
	loc_txt = 
	{
		name = 'American Joker',
		text = 
		{
			'Gains {X:mult,C:white}X0.1{} mult for every',
			'{C:attention}Hand{} with exactly 1 scoring {C:attention}face{} card',
			'{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:black,C:mult,s:0.8}Eyeriss{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Home alone\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 2, y = 5},
	rarity = 2,
	cost = 5,
	config = 
	{ 
		extra = 
		{
			Xmult = 1
		}
	},
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.Xmult}}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local faces = 0
            for i, v in ipairs(context.scoring_hand) do
				if v:is_face() then
					faces = faces + 1
				end
			end
			if faces == 1 then
				card.ability.extra.Xmult = card.ability.extra.Xmult + 0.1
				return
				{
					message = 'Upgrade!',
					colour = G.C.MULT,
					card = card
				}
			end
		end
		if context.joker_main then
			return
			{
				card = card,
				Xmult_mod = card.ability.extra.Xmult,
				message = 'X' .. card.ability.extra.Xmult,
				colour = G.C.MULT
			}
		end
	end
}


--Hole in One--
SMODS.Joker
{
	key = 'holei',
	blueprint_compat = true,
	loc_txt = 
	{
		name = 'Hole in One',
		text = 
		{
			'Gains {C:chips}+30{} chips if round',
			'is beaten in {C:attention}One Hand{}',
			'{C:inactive}(Currently {C:chips}+#1#{C:inactive} chips){}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:black,C:green,s:0.8}ThatoneDave{}{C:inactive,s:0.8} on the discord!{}',
			'\n',
			'{C:inactive}\'Fore!\'{}'
		}
	},
	atlas = 'Jokers',
	pos = {x = 3, y = 5},
	rarity = 1,
	cost = 5,
	config = 
	{ 
		extra = 
		{
			chips = 0
		}
	},
	
	loc_vars = function(self,info_queue,center)
		return {vars = {center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual and G.GAME.current_round.hands_played == 1 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + 30
			return
			{
				message = 'Upgrade!',
				colour = G.C.CHIPS,
				card = card
			}
		end
		if context.joker_main then
			return
			{
				card = card,
				chip_mod = card.ability.extra.chips,
				message = '+' .. card.ability.extra.chips,
				colour = G.C.CHIPS
			}
		end
	end
}