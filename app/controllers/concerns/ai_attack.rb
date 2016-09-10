module AiAttack
  extend ActiveSupport::Concern

  def barbarian_ai
    game_id = session[:game_id]
    game_info = Game.find(game_id)
    energy = game_info.round
    energy = 5 if energy > 5  #CANNOT HAVE MORE THAN 5 energy
    priority_list = []

    #Loop through card hand
    CardGroup.where(game_id: game_id, user_id: 0, current_hand_card: true).each do |card|
    end

  end

  def guardian_ai
  end

  def assassin_ai
  end

  def summoner_ai
  end

  def druid_ai
  end

end
