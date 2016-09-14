
module GameplayMethods
  extend ActiveSupport::Concern

  def determine_action
    action_played = params[:action_played]

    if action_played = 'defend'
      play_defense_card(params[:selected_card_id], params[:class_selected_id], params[:opponent_selected_id])
    elsif action_played = 'attack'
      play_attack_card(params[:selected_card_id], params[:class_selected_id], params[:opponent_selected_id])
    end


  def update_energy(used_energy, game_id)
    current_game = Game.find(game_id)
    new_energy = current_game.p1_energy - used_energy
    current_game.update(p1_energy: new_energy)
  end

  def set_inplay_to_cooldown
  end

  def update_player_hand
    current_game_id = session[:game_id]
    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)


    render partial: "game/gameplay/opponent_hand",layout: false
  end

  def update_gameplay_middle
    @player_attacking = params[:player_attacking]

    if @player_attacking == true
      @player_attack_card = SkillCard.find(params[:attack_card_id])
      render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
    else
      @opponent_attacking = true
      @opponent_attack_card = SkillCard.find(params[:attack_card_id])
      render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
    end
  end


  def update_gameplay_info
    render partial: "game/gameplay/info_windows/gameplay_ticker", layout: false
  end


end
