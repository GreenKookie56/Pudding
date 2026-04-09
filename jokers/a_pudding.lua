-- arrow format stolen from entropy
function FormatArrowMult(arrows, mult)
    mult = number_format(mult)
    if to_big(arrows) < to_big(-1) then 
        return "="..mult 
    elseif to_big(arrows) < to_big(0) then 
        return "+"..mult 
    elseif to_big(arrows) < to_big(6) then 
        if to_big(arrows) < to_big(1) then
            return "X"..mult
        end
        local arr = ""
        for i = 1, to_big(arrows):to_number() do
            arr = arr.."^"
        end
        return arr..mult
    else
        return "{"..arrows.."}"..mult
    end
end

if pud.config.pudding then


SMODS.Joker{ --King George
    key = "kinggeorge",
    config = {
        extra = {
            eor = 3,
            eor_mod = 0.2
        }
    },
    loc_txt = {
        ['name'] = 'King George',
        ['text'] = {
            [1] = 'Earn {C:gold}$#1#{} at end of round',
            [2] = 'increases by {C:gold}+$#2#{} when each',
            [3] = 'played {C:diamonds}Diamonds{} is scored'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {lenient_bignum(card.ability.extra.eor), lenient_bignum(card.ability.extra.eor_mod)}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  and not context.blueprint then
            if context.other_card:is_suit("Diamonds") then
                return {
                    func = function()
                    card.ability.extra.eor = lenient_bignum(card.ability.extra.eor) + lenient_bignum(card.ability.extra.eor_mod)
                    return true
                end,
                    message = localize('k_upgrade_ex'),
                    extra = {
                        colour = G.C.MONEY
                    }
                }
            end
        end
        if context.forcetrigger then
            card.ability.extra.eor = lenient_bignum(card.ability.extra.eor) + lenient_bignum(card.ability.extra.eor_mod)
                return {
                    dollars = lenient_bignum(card.ability.extra.eor),
                }
        end
    end,

    calc_dollar_bonus = function(self, card)
        if to_big(card.ability.extra.eor) > to_big(0) then
            return lenient_bignum(card.ability.extra.eor)
        end
    end
}
if Cryptid then
SMODS.Joker{ --Mabel
    key = "mabel",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Mabel',
        ['text'] = {
            [1] = 'When a hand is played,',
            [2] = '{C:attention}Randomize{} value of all Jokers',
            [3] = 'by {C:attention}X0.8{} to {C:attention}X1.3{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            local check = false
            for i = 1, #G.jokers.cards do
                if not (G.jokers.cards[i] == card) then
                    if not Card.no(G.jokers.cards[i], "immutable", true) then
                        check = true
                        local result = pseudorandom(pseudoseed("pud_mabel"), 80, 130)
						Cryptid.manipulate(G.jokers.cards[i], { value = result / 100 })
                        return {message = "X"..tostring(result / 100), colour = G.C.DARK_EDITION}
                    end
                end
            end
            if check then
            end
        end
    end
}
end
if next(SMODS.find_mod('Cryptid')) then
SMODS.Joker{ --Buchi
    key = "buchi",
    config = {
        extra = {
            mult = 0.9,
            active = 0,
            scale = 0.05
        }
    },
    loc_txt = {
        ['name'] = 'Buchi',
        ['text'] = {
            [1] = '{X:legendary,C:white}^#1#{} Mult',
            [2] = 'Decrease by {X:legendary,C:white}#3#{}',
            [3] = 'when a hand is played',
            [4] = 'Permanently sets to {X:legendary,C:white}^3.57{} Mult',
            [5] = 'once this reaches {X:legendary,C:white}0{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.active, card.ability.extra.scale}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if ((card.ability.extra.active or 0) == 0 and (card.ability.extra.mult or 0) > 0) and not context.forcetrigger then
                return {
                    func = function()
                    card.ability.extra.mult = math.max(0, (card.ability.extra.mult) - card.ability.extra.scale)
                    return true
                end
                }
            elseif ((card.ability.extra.active or 0) == 0 and (card.ability.extra.mult or 0) <= 0) and not context.forcetrigger then
                return {
                    func = function()
                    card.ability.extra.mult = 3.57
                    return true
                end,
                    extra = {
                        func = function()
                    card.ability.extra.active = 1
                    return true
                end,
                        colour = G.C.BLUE
                        }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main then
                return {
                    e_mult = card.ability.extra.mult
                }
        end
        if context.forcetrigger and card.ability.extra.active == 0 then
                return {
                    func = function()
                    card.ability.extra.mult = 3.57
                    return true
                end,
                    extra = {
                        func = function()
                    card.ability.extra.active = 1
                    return true
                end,
                        colour = G.C.BLUE
                        }
                }
        end
        if context.forcetrigger and card.ability.extra.active ~= 0 then
                return {
                    e_mult = card.ability.extra.mult
                }
        end
    end
}

SMODS.Joker{ --Taisho
	key = "taisho",
	rarity = 3,
	cost = 9,
  loc_txt = {
        ['name'] = 'Taisho',
        ['text'] = {
            [1] = '{C:attention}Force-trigger{} the Joker to the right',
            [2] = 'for the last hand of the round'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
	blueprint_compat = false,
	demicoloncompat = true,
  unlocked = true,
  discovered = true,
	pos = { x = 8, y = 5 },
  atlas = 'CustomJokers',
	calculate = function(self, card, context)
	-- Thanks cryptid mod devs you're awesome
		if context.joker_main and G.GAME.current_round.hands_left <= 0 and not context.blueprint then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					if Cryptid.demicolonGetTriggerable(G.jokers.cards[i + 1])[1] then
						local results = Cryptid.forcetrigger(G.jokers.cards[i + 1], context)
						if results and results.jokers then
							results.jokers.message = localize("cry_demicolon")
							results.jokers.colour = G.C.RARITY.cry_epic
							results.jokers.sound = "cry_demitrigger"
							return results.jokers
						end
						return {
							message = localize("cry_demicolon"),
							colour = G.C.RARITY.cry_epic,
							sound = "cry_demitrigger",
						}
					end
				end
			end
		end
	end
}
end
SMODS.Joker{ --Ten the purples
    key = "tenthepurples",
    config = {
    },
    loc_txt = {
        ['name'] = 'Ten the purples',
        ['text'] = {
            [1] = 'When {C:attention}Boss Blind{} is selected,',
            [2] = '{C:attention}disable{} Blind effect and {C:red}X2{} Blind size',
            [3] = '{C:inactive,s:0.7}haha every boss blinds are the wall now{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 3,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    calculate = function(self, card, context)
        if context.setting_blind  and not context.blueprint then
            if G.GAME.blind.boss then
                return {
                    func = function()
                        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.blind:disable()
                                    play_sound('timpani')
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled'), colour = G.C.GREEN})
                        end
                        return true
                    end,
                    extra = {
                        
                        func = function()
                            if G.GAME.blind.in_blind then
                                G.GAME.blind.chips = G.GAME.blind.chips * 2
                                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                                G.HUD_blind:recalculate()
                                return true
                            end
                        end,
                        colour = G.C.GREEN
                    }
                }
            end
        end
    end
}
if Talisman then

SMODS.Joker{ --The Pudding
    key = "thepudding",
    config = {
        extra = {
            operator = 0,
            mult = 1.7
        }
    },
    loc_txt = {
        ['name'] = 'The Pudding',
        ['text'] = {
            [1] = '{X:dark_edition,C:white}#1#{} Mult',
            [2] = '{X:dark_edition,C:white}operator{} increases once if',
            [3] = 'played hand contains a',
            [4] = '{C:attention}Straight Flush{} and {C:attention}7{} of {C:clubs}Clubs{}',
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 30,
    rarity = "pud_peculiar",
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' and args.source ~= 'rta' and args.source ~= 'sou' and args.source ~= 'uta' and args.source ~= 'wra' 
            or args.source == 'sho'
        )
        and true
    end,
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {FormatArrowMult(math.ceil(card.ability.extra.operator), card.ability.extra.mult)}}
    end,
    
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if (next(context.poker_hands["Straight Flush"]) and (function()
                local count = 0
                for _, playing_card in pairs(context.full_hand or {}) do
                    if playing_card:get_id() == 7 then
                        count = count + 1
                    end
                end
                return count >= 1
            end)() and (function()
                local count = 0
                for _, playing_card in pairs(context.full_hand or {}) do
                    if playing_card:is_suit("Clubs") then
                        count = count + 1
                    end
                end
                return count >= 1
            end)()) then
                return {
                    func = function()
                        card.ability.extra.operator = (card.ability.extra.operator) + 1
                        return true
                    end,
                    message = localize('k_upgrade_ex')
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then
			if to_big(card.ability.extra.operator) <= to_big(-1) then
				return {
					mult = lenient_bignum(card.ability.extra.mult)
				}
			elseif to_big(card.ability.extra.operator) == to_big(0) then
				return {
                    Xmult = lenient_bignum(card.ability.extra.mult)
				}
			elseif to_big(card.ability.extra.operator) == to_big(1) then
				return {
					emult = lenient_bignum(card.ability.extra.mult)
				}
			elseif to_big(card.ability.extra.operator) == to_big(2) then
				return {
					eemult = lenient_bignum(card.ability.extra.mult)
				}
			elseif to_big(card.ability.extra.operator) > to_big(2) then
				return {
					hypermult = {
						lenient_bignum(math.ceil(card.ability.extra.operator)),
						lenient_bignum(card.ability.extra.mult)
					}
				}
			end
        end
    end
}

end
end