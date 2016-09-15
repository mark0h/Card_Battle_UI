

module Defend
  extend ActiveSupport::Concern

  def play_defense_card(defend_card_id, class_selected_id, opponent_selected_id)
    logger.info "play_defense_card defense_card: #{defend_card_id}"
    @opponent_attacking = true
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    player_class = ClassCard.find(class_selected_id)
    opponent_class = ClassCard.find(opponent_selected_id)
    defend_card = SkillCard.find(defend_card_id)

    #There should only be one in play card! How to make sure of this?
    attack_card_used = CardGroup.where(game_id: current_game_id, inplay_card: true).first
    attack_card = SkillCard.find(attack_card_used.card_id)

    @defense_card = ''
    @opponent_attack_card = attack_card
    @defense_error = false
    @round_number = current_game.round

    energy_left = Game.find(current_game_id).p1_energy

    #Check energy left over, if not enough, cannot play card. If enough energy PLAY the card
    if energy_left < defend_card.cost
      @defense_error = true
      @defense_card = 'error'
      @error_message = "You do not have enough energy to play that card!"
      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    else

      # CHeck if this card can be played, since only defense cards can be played to defend, if it is, change its card group status to in play, if not return an error to the partial.
      if defend_card.card_type == 'defense'
        #Update card to inplay
        card_used = CardGroup.where(game_id: current_game_id, user_id: current_user.id, card_id: defend_card_id).first
        card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)

        #Update energy
        update_energy(defend_card.cost, current_game_id)

        #Update whose turn information
        current_game.update(whose_turn: 11)  #Update to player 1 attacking(1)
        @defense_card = defend_card
        @damage_taken, @damage_returned = take_damage(current_game, current_user.id, player_class, opponent_class, defend_card, attack_card)

        render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
      else
        logger.info "play_defense_card error: Not a valid defense card!"
        @defense_error = true
        @defense_card = 'error'
        @error_message = "That card is not a defense card, and cannot be played at this time."
        render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
      end

    end

  end

    def take_damage(current_game, player_id, player_class, opponent_class, defense_card, attack_card)
      player_health = current_game.p1_health
      opponent_health = current_game.p2_health

      #First calculate the total damage the player will take
      player_damage_taken = attack_card.damage
      player_damage_type = attack_card.attack_type
      player_defense_bonus = send("#{defense_card.bonus_method}", player_damage_type, 'defense')
      player_class_damage_defense = send("#{player_class.name.downcase}_damage_defense", player_damage_type)

      #Then calculate the total damage they return to the opponent.
      opponent_damage_taken = defense_card.damage
      opponent_damage_type = defense_card.attack_type
      opponent_attack_bonus = send("#{attack_card.bonus_method}", opponent_damage_type, 'attack')
      opponent_class_damage_defense = send("#{player_class.name.downcase}_damage_defense", opponent_damage_type)
      #player_damage_taken.to_i + player_damage_type.to_i + player_attack_bonus[:block].to_i + player_class_damage_defense.to_i + opponent_defense_bonus[:damage_bonus]
      player_total_damage_taken = player_damage_taken.to_i + player_defense_bonus[:block].to_i + player_class_damage_defense.to_i + opponent_attack_bonus[:damage_bonus]

      player_remaining_health = player_health - player_total_damage_taken
      player_remaining_health = 0 if player_remaining_health < 0

      opponent_total_damage_taken = opponent_damage_taken.to_i + opponent_class_damage_defense.to_i + player_defense_bonus[:damage_bonus]

      opponent_remaining_health = opponent_health - opponent_total_damage_taken
      opponent_remaining_health = 0 if opponent_remaining_health < 0

      current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)

      return player_total_damage_taken, opponent_total_damage_taken

    end





end
