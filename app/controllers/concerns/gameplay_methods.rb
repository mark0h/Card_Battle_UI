
module GameplayMethods
  extend ActiveSupport::Concern

  def determine_action
    action_played = params[:action_played]

    if action_played == 'defend'
      play_defense_card(params[:selected_card_id], params[:class_selected_id], params[:opponent_selected_id])
    elsif action_played == 'attack'
      play_attack_card(params[:selected_card_id], params[:class_selected_id], params[:opponent_selected_id])
    elsif action_played == 'continue_round'
      continue_round
    elsif action_played == 'new_round'
      play_next_round
    end

  end

  def continue_round
    set_inplay_to_cooldown
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)

    whose_turn = current_game.whose_turn
    logger.info "continue_round info: whose_turn: #{whose_turn}"

    if whose_turn == 22
       @opponent_attacking = true
      @opponent_attack_card = ai_attack_card(params[:opponent_selected_id])
      render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
    else
       @opponent_attacking = false
      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    end

  end



  def update_energy(used_energy, game_id)
    current_game = Game.find(game_id)
    new_energy = current_game.p1_energy - used_energy
    current_game.update(p1_energy: new_energy)
  end

  def set_inplay_to_cooldown
    CardGroup.where(inplay_card: true).each do |inplay_card|
      card_values = SkillCard.find(inplay_card.card_id)
      inplay_card.update(current_hand_card: false, deck_card: false, cooldown_card: true, inplay_card: false, cooldown_remaining: card_values.cooldown)
    end

  end

  #Loops through all cards in cooldown, subtracts 1 from cooldown remaining. Any at 0 gets added to the deck, the rest have value updated only
  def set_cooldown_to_deck
    CardGroup.where(cooldown_card: true).each do |cooldown_card|
      cooldown_update = cooldown_card.cooldown - 1
      if cooldown_update < 1
        cooldown_card.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false, cooldown_remaining: cooldown_update)
      else
        cooldown_card.update(cooldown_remaining: cooldown_update)
      end
    end
  end

  def update_player_hand
    current_game_id = session[:game_id]
    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)


    if params[:from_action] == 'defend'
      render partial: "game/gameplay/player_hand/defend_round_hand",layout: false
    elsif params[:from_action] == 'attack'
      render partial: "game/gameplay/player_hand/attack_round_hand",layout: false
    else
      render partial: "game/gameplay/player_hand/in_progress_hand",layout: false
    end

  end

  def update_gameplay_middle
    @player_attacking = params[:player_attacking]

    if @player_attacking == true
      @opponent_attacking = false
      @player_attack_card = SkillCard.find(params[:attack_card_id])
      render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
    else
      @opponent_attacking = true
      @opponent_attack_card = SkillCard.find(params[:attack_card_id])
      render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
    end
  end


  def update_gameplay_ticker
    render partial: "game/gameplay/info_windows/gameplay_ticker", layout: false
  end


end
