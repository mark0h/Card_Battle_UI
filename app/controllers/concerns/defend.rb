

module Defend
  extend ActiveSupport::Concern

  def play_defense_card(defend_card_id, class_selected_id, opponent_selected_id)
    logger.info "play_defense_card defense_card: #{defend_card_id}"
    @opponent_attacking = true
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    player_class = ClassCard.find(class_selected_id)
    opponent_class = ClassCard.find(opponent_selected_id)

    #There should only be one in play card! How to make sure of this?
    attack_card_used = CardGroup.where(game_id: current_game_id, inplay_card: true).first
    attack_card = SkillCard.find(attack_card_used.card_id) unless attack_card_used.nil?

    @defense_card = ''
    @opponent_attack_card = attack_card
    @round_number = current_game.round
    @player_skipped = false

    if defend_card_id.to_i == 0
      @player_skipped = true

      #Update whose turn information
      current_game.update(whose_turn: 11)  #Update to player 1 attacking(1)
      @damage_taken, @damage_returned = take_damage(current_game, current_user.id, player_class, opponent_class, nil, attack_card)

      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    else
      defend_card = SkillCard.find(defend_card_id)

      #Update card to inplay
      card_used = CardGroup.where(game_id: current_game_id, user_id: current_user.id, card_id: defend_card_id).first
      card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)

      #Update energy
      update_energy(defend_card.cost, current_game_id, status_bonus)

      #Update whose turn information
      current_game.update(whose_turn: 11)  #Update to player 1 attacking(1)
      @defense_card = defend_card
      @damage_taken, @damage_returned = take_damage(current_game, current_user.id, player_class, opponent_class, defend_card, attack_card)

      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    end


  end

    def take_damage(current_game, player_id, player_class, opponent_class, defense_card, attack_card)
      return 0, 0 if defense_card.nil? && attack_card.nil?
      player_health = current_game.p1_health
      opponent_health = current_game.p2_health

      player_damage_type_taken = attack_card.attack_type

      #Calculate the total damage the opponent will take
    if defense_card.nil?
      opponent_total_damage_taken= 0
      opponent_damage_type_taken = 'x'
      player_defense_bonus = {block: 0, damage_bonus: 0}
    else
      opponent_damage_taken = defense_card.damage
      opponent_damage_type_taken = defense_card.attack_type
      player_defense_bonus = send("#{defense_card.bonus_method}", player_damage_type_taken, 'defense')
      opponent_class_damage_defense = send("#{opponent_class.name.downcase}_damage_defense", opponent_damage_type_taken)

      opponent_total_damage_taken = opponent_damage_taken.to_i + opponent_class_damage_defense.to_i + player_defense_bonus[:damage_bonus]
    end

    #Calculate the total damage opponent returns to player
    player_damage_taken = attack_card.damage
    opponent_attack_bonus = send("#{attack_card.bonus_method}", opponent_damage_type_taken, 'attack')
    player_class_damage_defense = send("#{opponent_class.name.downcase}_damage_defense", player_damage_type_taken)

    player_total_damage_taken = player_damage_taken.to_i + player_defense_bonus[:block] + player_class_damage_defense.to_i + opponent_attack_bonus[:damage_bonus]

    opponent_remaining_health = opponent_health - opponent_total_damage_taken
    opponent_remaining_health = 0 if opponent_remaining_health < 0

    player_remaining_health = player_health - player_total_damage_taken
    player_remaining_health = 0 if player_remaining_health < 0

      current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)

      return player_total_damage_taken, opponent_total_damage_taken

    end

end
