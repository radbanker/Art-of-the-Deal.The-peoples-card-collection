--Quartered Deck--
SMODS.Back
{
	key = 'quart',
	loc_txt =
	{
		name = 'Quartered Deck',
		text =
		{
			'Start with {C:attention}13 Cards{}',
			'from {C:attention}Ace{} to {C:attention}King{}',
			'Each card has a random {C:attention}suit{}'
		}
	},
	atlas = 'Decks',
	pos = { x = 0, y = 0 },
	apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
				for i = #G.playing_cards, 1, -1 do
					if i <= 13 then
						SMODS.change_base(G.playing_cards[i], pseudorandom_element(SMODS.Suits, pseudoseed("your_key")).key)
                    elseif i >= 14 then
                        G.playing_cards[i]:start_dissolve(nil, true)
                    end
				end
				return true
			end
		}))
	end
}




--Premium Deck--
SMODS.Back
{
	key = 'premi',
	loc_txt =
	{
		name = 'Premium Deck',
		text =
		{
			'Start with {C:green}Premium{} and {C:red}Top Shelf{}',
			'Cost of everything is increased',
            'by {C:money}$1{} every {C:attention}even ante{}',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:purple,C:white,s:0.8}Kars{}{C:inactive,s:0.8} on the discord!{}',
		}
	},
	atlas = 'Decks',
	pos = { x = 1, y = 0 },
	config =
	{
		vouchers =
		{
			'v_deal_premi',
			'v_deal_topsh'
		},
	},
	calculate = function(self,back,context)
		if context.setting_blind and context.blind.boss and G.GAME.round_resets.ante % 2 == 0 then
			G.GAME.inflation = G.GAME.inflation + 1
		end
	end
}


--voucher deck--
SMODS.Back
{
	key = 'vouch',
	loc_txt =
	{
		name = 'Coupon Deck',
		text =
		{
			'WIP',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:green,C:white,s:0.8}Hat Stack{}{C:inactive,s:0.8} on the discord!{}',
		}
	},
	atlas = 'Decks',
	pos = { x = 2, y = 0 },
	config =
	{
		
	},
	calculate = function(self,back,context)

	end
}


--Carnival Deck--
SMODS.Back
{
	key = 'carne', --hehe carne lol          looking for some "interesting furry art" (hint hint nudge nudge) you can probably find them in the usual places
	loc_txt =
	{
		name = 'Carnival Deck',
		text =
		{
			'WIP',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:green,C:white,s:0.8}Hat Stack{}{C:inactive,s:0.8} on the discord!{}',
		}
	},
	atlas = 'Decks',
	pos = { x = 0, y = 1 },
	config =
	{
		
	},
	calculate = function(self,back,context)

	end
}


--Overcrowded Deck--
SMODS.Back
{
	key = 'overc',
	loc_txt =
	{
		name = 'Overcrowded Deck',
		text =
		{
			'WIP',
			'{C:inactive,s:0.8}Original art and concept by{}',
			'{X:green,C:white,s:0.8}Hat Stack{}{C:inactive,s:0.8} on the discord!{}',
		}
	},
	atlas = 'Decks',
	pos = { x = 1, y = 1 },
	config =
	{
		
	},
	calculate = function(self,back,context)

	end
}