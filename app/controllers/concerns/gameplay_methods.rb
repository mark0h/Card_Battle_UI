
module GameplayMethods
  extend ActiveSupport::Concern

  def determine_action
    action_played = params[:action_played]

    if action_played == 'defend'
      play_defense_card(params[:card_selected_id], params[:class_selected_id], params[:opponent_selected_id])
    elsif action_played == 'attack'
      play_attack_card(params[:card_selected_id], params[:class_selected_id], params[:opponent_selected_id])
    elsif action_played == 'continue_round'
      continue_round
    elsif action_played == 'skip_attack'
      skip_attack
    elsif action_played == 'new_round'
      play_next_round(params[:class_selected_id], params[:opponent_selected_id])
    end

  end

  def verify_card_use
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)
    p1_energy = current_game.p1_energy
    play_card = SkillCard.find(params[:selected_card_id])
    usable = true
    error_text = ""

    #There should only be one in play card! How to make sure of this?
    attack_card_used = CardGroup.where(game_id: current_game_id, inplay_card: true).first
    attack_card = SkillCard.find(attack_card_used.card_id) unless attack_card_used.nil?
    attack_card_attack_type = 'x'
    attack_card_attack_type = attack_card.attack_type unless attack_card_used.nil?

    energy_cost_bonus = calculate_effect_energy(current_user.id).to_i
    total_card_cost = energy_cost_bonus + play_card.cost

    logger.info "verify_card_use: params[:player_action]: #{params[:player_action]} play_card.card_type: #{play_card.card_type} attack_card.attack_type: #{attack_card_attack_type}"

    if p1_energy < total_card_cost
      usable = false
      error_text = "Not enough energy to use this card"
    else
      if params[:player_action] == 'defense' && play_card.card_type != 'defense'
        usable = false
        error_text = "#{play_card.name} is not a valid defense card!"
      elsif params[:player_action] == 'defense'
        defense_validation = send("#{play_card.bonus_method}", attack_card_attack_type, 'defense', current_user.id)
        usable = defense_validation[:allowed]
        error_text = defense_validation[:error_text]
      end
    end

    return_hash = {play_card: play_card, usable: usable, error_text: error_text}

    render json: return_hash

  end

  def skip_attack
    @opponent_attacking = true
    @opponent_attack_card = ai_attack_card(params[:opponent_selected_id])
    render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
  end

  def continue_round
    death_status = check_death

    if death_status == 'none'
      @death_status = false
      @death_img = ''
    else
      @death_status = true
      @death_img = death_status
    end

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

  def play_next_round(class_selected_id, opponent_selected_id)
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    @player_one_class = ClassCard.find(class_selected_id)
    @opponent_class = ClassCard.find(opponent_selected_id)

    @player_one_priority = @player_one_class.turn_priority
    @opponent_priority = @opponent_class.turn_priority

    if @player_one_priority < @opponent_priority
      @whose_turn = 11
    elsif @player_one_priority > @opponent_priority
      @whose_turn = 21
    else
      r = Random.rand(1..2)
      @whose_turn = "#{r}1".to_i
    end

    #Set any inplay cards to cooldown
    set_inplay_to_cooldown

    #Set cooldown cards to deck if ready
    set_cooldown_to_deck

    #Increase round count
    round_number = current_game.round + 1

    #set energy
    p1_energy = round_number
    p1_energy = 5 if p1_energy > 5
    p2_energy = round_number
    p2_energy = 5 if p2_energy > 5

    #Remove statuses
    remove_status?(current_game.user_id, 'round')
    remove_status?(current_game.opponent_id, 'round')

    #Update game
    current_game.update(whose_turn: @whose_turn, round: round_number, p1_energy: p1_energy, p2_energy: p2_energy)

    #Update deck, put back cards in hand to deck
    CardGroup.where(game_id: current_game_id, deck_card: false, cooldown_card: false).each do |inplay_card|
      inplay_card.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false)
    end

    CardGroup.where(game_id: current_game_id, user_id: current_user.id).each do |game_card|
      logger.info "play_next_round: player cards:  game_card 2: #{game_card.inspect}"
    end

    render partial: 'game/gameplay/round/pre_round_setup', layout: false

  end


  def update_energy(used_energy, game_id, status_bonus)
    current_game = Game.find(game_id)

    final_energy_cost = used_energy + status_bonus
    logger.info "update_energy final_energy_cost: #{final_energy_cost} (#{used_energy} + #{status_bonus})"
    final_energy_cost = 0 if final_energy_cost < 0

    new_energy = current_game.p1_energy - final_energy_cost
    current_game.update(p1_energy: new_energy)
  end

  def set_inplay_to_cooldown
    current_game_id = session[:game_id]
    CardGroup.where(game_id: current_game_id, inplay_card: true).each do |inplay_card|
      card_values = SkillCard.find(inplay_card.card_id)
      inplay_card.update(current_hand_card: false, deck_card: false, cooldown_card: true, inplay_card: false, cooldown_remaining: card_values.cooldown)
    end

  end

  #Loops through all cards in cooldown, subtracts 1 from cooldown remaining. Any at 0 gets added to the deck, the rest have value updated only
  def set_cooldown_to_deck
    current_game_id = session[:game_id]
    CardGroup.where(game_id: current_game_id, cooldown_card: true).each do |cooldown_card|
      logger.info "set_cooldown_to_deck: cooldown_card: #{cooldown_card.inspect}"
      if cooldown_card.cooldown_remaining < 1
        cooldown_card.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false, cooldown_remaining: 0)
      else
        cooldown_update = cooldown_card.cooldown_remaining - 1
        cooldown_card.update(cooldown_remaining: cooldown_update)
      end
    end
  end

  def update_player_hand
    current_game_id = session[:game_id]
    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)

    @player_one_status_list = return_status_list(current_user.id)

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

  def check_death
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    player_health = current_game.p1_health
    opponent_health = current_game.p2_health

    if player_health == 0 && opponent_health == 0
      return 'both'
    end

    return 'player' if player_health == 0
    return 'opponent' if opponent_health == 0

    return 'none'
  end


end
