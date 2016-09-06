# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).first_or_create.
#
# Examples:
#
#   cities = City.where([{ name: 'Chicago' }, { name: 'Copenhagen' }]).first_or_create
#   Mayor.where(name: 'Emanuel', city: cities.first).first_or_create

barbarian_class = ClassCard.where(name: 'Barbarian', health: 45, base_stat: 'strength', mp: 0, rp: 0, ms: 2, rs: 2, notes: 'Attacks hit multiple targets, weak spell defense', ally: 'Spirit Ancestors').first_or_create
guardian_class = ClassCard.where(name: 'Guardian', health: 50, base_stat: 'endurance', mp: -2, rp: -2, ms: 0, rs: -1, notes: 'Lots of defense moves, but low attack damage. ', ally: 'Templars').first_or_create
assassin_class = ClassCard.where(name: 'Assassin', health: 45, base_stat: 'agility', mp: 1, rp: 1, ms: 1, rs: 1, notes: 'Attacks first, low defense with high powered single target skills. ', ally: 'Shadow Demons').first_or_create
summoner_class = ClassCard.where(name: 'Summoner', health: 40, base_stat: 'intellect', mp: 2, rp: 2, ms: -2, rs: -2, notes: 'Can summon up to 3 minions. Weak physical defense, strong spell defense.', ally: 'Minions').first_or_create
druid_class = ClassCard.where(name: 'Druid', health: 50, base_stat: 'willpower', mp: -2, rp: -1, ms: -1, rs: -2, notes: 'Good defense, has both physical and spell attacks. ', ally: 'Spirit Ancestors').first_or_create

barbarian_class.update(image_path: 'barbarian_card.png')
guardian_class.update(image_path: 'guardian_card.png')
assassin_class.update(image_path: 'assassin_card.png')
summoner_class.update(image_path: 'summoner_card.png')
druid_class.update(image_path: 'druid_card.png')
