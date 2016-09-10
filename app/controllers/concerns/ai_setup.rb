module AiSetup
  extend ActiveSupport::Concern

  def barbarian_setup
    game_id = session[:game_id]
    game_info = Game.find(game_id)
    energy = game_info.round
    energy = 5 if energy > 5  #CANNOT HAVE MORE THAN 5 energy
    priority_list = []

    #Loop through card hand
    CardGroup.where(game_id: game_id, user_id: 0, current_hand_card: true).each do |card|
    end

  end

  def guardian_setup
  end

  def assassin_setup
  end

  def summoner_setup
  end

  def druid_setup
  end

end
