# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).first_or_create.
#
# Examples:
#
#   cities = City.where([{ name: 'Chicago' }, { name: 'Copenhagen' }]).first_or_create
#   Mayor.where(name: 'Emanuel', city: cities.first).first_or_create

# barbarian_class = ClassCard.where(name: 'Barbarian', health: 45, base_stat: 'strength', mp: 0, rp: 0, ms: 2, rs: 2, notes: 'Attacks hit multiple targets, weak spell defense', ally: 'Spirit Ancestors').first_or_create
# guardian_class = ClassCard.where(name: 'Guardian', health: 50, base_stat: 'endurance', mp: -2, rp: -2, ms: 0, rs: -1, notes: 'Lots of defense moves, but low attack damage. ', ally: 'Templars').first_or_create
# assassin_class = ClassCard.where(name: 'Assassin', health: 45, base_stat: 'agility', mp: 1, rp: 1, ms: 1, rs: 1, notes: 'Attacks first, low defense with high powered single target skills. ', ally: 'Shadow Demons').first_or_create
# summoner_class = ClassCard.where(name: 'Summoner', health: 40, base_stat: 'intellect', mp: 2, rp: 2, ms: -2, rs: -2, notes: 'Can summon up to 3 minions. Weak physical defense, strong spell defense.', ally: 'Minions').first_or_create
# druid_class = ClassCard.where(name: 'Druid', health: 50, base_stat: 'willpower', mp: -2, rp: -1, ms: -1, rs: -2, notes: 'Good defense, has both physical and spell attacks. ', ally: 'Spirit Ancestors').first_or_create
#
# barbarian_class.update(image_path: 'barbarian_card.png')
# guardian_class.update(image_path: 'guardian_card.png')
# assassin_class.update(image_path: 'assassin_card.png')
# summoner_class.update(image_path: 'summoner_card.png')
# druid_class.update(image_path: 'druid_card.png')
#
# SkillCard.create(name: 'Overpower', class_id: 1, card_type: 'defense', cost: 1, attack_type: 'mp', attack_targets: 1, damage: 4, description: 'Blocks 1/2 incoming Melee Physical', bonus_method: 'barbarian_overpower', buff_id: nil, debuff_id: nil, cooldown: 1, image_path: 'overpower.png')
# SkillCard.create(name: 'Ground Slam', class_id: 1, card_type: 'attack', cost: 1, attack_type: 'mp', attack_targets: 2, damage: 4, description: 'Slams down in an area of effect, damaging all.', bonus_method: 'barbarian_groundslam', buff_id: nil, debuff_id: nil, cooldown: 0, image_path: 'groundslam.png')
# SkillCard.create(name: 'Barbaric Insight', class_id: 1, card_type: 'buff', cost: 1, attack_type: 'mp', attack_targets: 1, damage: 0, description: 'Grants Insight, preventing ranged damage for 1 turn', bonus_method: 'barbarian_insight', buff_id: nil, debuff_id: nil, cooldown: 1, image_path: 'barbaricinsight.png')
# SkillCard.create(name: 'Whirlwind', class_id: 1, card_type: 'attack', cost: 2, attack_type: 'mp', attack_targets: 2, damage: 6, description: 'Spins weapon in a blaze of fury, hitting all targets. ', bonus_method: 'barbarian_whirlwind', buff_id: nil, debuff_id: nil, cooldown: 2, image_path: 'whirlwind.png')
# SkillCard.create(name: 'Dragon Roar', class_id: 1, card_type: 'buff', cost: 2, attack_type: 'mp', attack_targets: 1, damage: 0, description: 'Gain Fury, adding +2 damage per skill for 1 attack', bonus_method: 'barbarian_roar', buff_id: nil, debuff_id: nil, cooldown: 2, image_path: 'dragonroar.png')
# SkillCard.create(name: 'Death by Axe', class_id: 1, card_type: 'attack', cost: 4, attack_type: 'mp', attack_targets: 2, damage: 12, description: 'Seek the blood of all your enemies while gaining Unstoppable, reducing the cost of all skills to nothing this round.', bonus_method: 'barbarian_deathbyaxe', buff_id: nil, debuff_id: nil, cooldown: 1, image_path: 'deathbyaxe.png')
# SkillCard.create(name: 'Axe Bezerker', class_id: 1, card_type: 'attack', cost: 3, attack_type: 'mp', attack_targets: 2, damage: 8, description: 'Attack all targets, or does +2 damage to single target.', bonus_method: 'barbarian_bezerker', buff_id: nil, debuff_id: nil, cooldown: 1, image_path: 'bezerker.png')
# SkillCard.create(name: 'Tribal Totem', class_id: 1, card_type: 'buff', cost: 3, attack_type: 'mp', attack_targets: 1, damage: 0, description: 'Grants 2 random buffs.', bonus_method: 'barbarian_totem', buff_id: nil, debuff_id: nil, cooldown: 1, image_path: 'totem.png')
#

CardPriority.create(class_id: 1, card_id: 1, opponent_class_id: 0, energy_cost: 1, priority: 2)
CardPriority.create(class_id: 1, card_id: 2, opponent_class_id: 0, energy_cost: 1, priority: 3)
CardPriority.create(class_id: 1, card_id: 3, opponent_class_id: 0, energy_cost: 1, priority: 1)
CardPriority.create(class_id: 1, card_id: 4, opponent_class_id: 0, energy_cost: 2, priority: 4)
CardPriority.create(class_id: 1, card_id: 5, opponent_class_id: 0, energy_cost: 2, priority: 10)
CardPriority.create(class_id: 1, card_id: 6, opponent_class_id: 0, energy_cost: 4, priority: 8)
CardPriority.create(class_id: 1, card_id: 7, opponent_class_id: 0, energy_cost: 3, priority: 7)
CardPriority.create(class_id: 1, card_id: 8, opponent_class_id: 0, energy_cost: 3, priority: 9)
