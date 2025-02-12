--Premium Voucher--
SMODS.Voucher
{
    key = 'premi',
    loc_txt =
    {
        name = 'Premium',
        text =
        {
            '{C:attention}Uncommon Jokers{} appear',
            '{C:attention}2X{} as often',
            '{C:inactive,s:0.8}Original art and concept by{}',
			'{X:purple,C:white,s:0.8}Kars{}{C:inactive,s:0.8} on the discord!{}',
        }
    },
    atlas = 'Vouchers', pos = { x = 0, y = 0 },
    redeem = function(self, card)
        G.GAME.uncommon_mod = G.GAME.uncommon_mod * 2
    end
}

--Top Shelf--
SMODS.Voucher
{
    key = 'topsh',
    loc_txt =
    {
        name = 'Top Shelf',
        text =
        {
            '{C:attention}Rare Jokers{} appear',
            '{C:attention}4X{} as often',
            '{C:inactive,s:0.8}Original art and concept by{}',
			'{X:purple,C:white,s:0.8}Kars{}{C:inactive,s:0.8} on the discord!{}',
        }
    },
    atlas = 'Vouchers', pos = { x = 1, y = 0 },
    requires = {'v_deal_premi'},
    redeem = function(self, card)
        G.GAME.rare_mod = G.GAME.rare_mod * 4
    end
}