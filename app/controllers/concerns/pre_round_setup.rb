# USE THIS LIST TO SEARCH FOR METHODS
#
# 1. NEW GAME SETUP
# 2. SAVED GAME SETUP
# 3. GET PLAYER'S CURRENT DECK
# 4. ADD CARD TO PLAYER HAND
# 5. REMOVE CARD FROM PLAYER HAND
# 6. UPDATE STATUS WINDOW


module PreRoundSetup
  extend ActiveSupport::Concern

  #    1. NEW GAME SETUP
  def setup_new_game
    logger.info "Setting up new game"
    @player_one_class = ClassCard.find(params[:class_selected_id])
    @opponent_class = ClassCard.find(params[:opponent_selected_id])
    @player_one_health = @player_one_class.health
    @opponent_health = @opponent_class.health
    @round_number = 1

    logger.info "@player_one_class: #{@player_one_class.inspect}"
    logger.info "@opponent_class: #{@opponent_class.inspect}"

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

    logger.info "@whose_turn: #{@whose_turn}"

    @player_one_current_deck = SkillCard.where(class_id: params[:class_selected_id])
    @opponent_current_deck = SkillCard.where(class_id: params[:opponent_selected_id])


    new_game = Game.where(p1_health: @player_one_health, p2_health: @opponent_health, round: @round_number, user_id: current_user.id, opponent_id: 0, p1_energy: 1, p2_energy: 1).first_or_create
    new_game.update(whose_turn: @whose_turn)

    #Add all cards as deck cards to CardGroup
    @player_one_current_deck.each do |card|
      d_card = CardGroup.where(game_id: new_game.id, card_id: card.id, user_id: current_user.id).first_or_create
      d_card.update(cooldown_remaining: 0, current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false, image_path: card.image_path)
      d_card.save
    end

    #Add all cards as deck cards to CardGroup
    @opponent_current_deck.each do |card|
      d_card = CardGroup.where(game_id: new_game.id, card_id: card.id, user_id: 0).first_or_create
      d_card.update(cooldown_remaining: 0, current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false, image_path: card.image_path)
      d_card.save
    end

    session[:game_id] = new_game.id

    render partial: 'game/gameplay/round/pre_round_setup', layout: false
  end

  #     2. SAVED GAME SETUP
  def load_saved_game
  end

 #     3. GET PLAYER'S CURRENT DECK
  def get_current_deck
    current_game_id = session[:game_id]
    @player_one_current_deck = CardGroup.where(game_id: current_game_id, user_id: current_user.id, deck_card: true)
    render partial: 'game/gameplay/player_deck', layout: false
  end


  # ============================================
  #    4. ADD CARD TO PLAYER HAND
  #    CALLED WHEN PLAYER CLICKS ON A CARD IN HIS DECK
  # ============================================
  def add_card_to_hand
    current_game_id = session[:game_id]

    #SET up the instance variables used in the partials to render the different cards
    @player_one_current_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)

    #First verify there is room in the current hand to add another card, if so, change that card_id current_hand value to true and deck_card to false
    if @player_one_current_hand.length > 2
      flash.now[:error] = "You must remove a card from your hand first! Can only have 3 cards "
    else
      card_id_to_add = params[:add_to_hand].gsub(/_selected/,'').to_i
      card_add = CardGroup.where(game_id: current_game_id, user_id: current_user.id, card_id: card_id_to_add).first
      card_add.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)

    end

    @player_one_current_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)
    render partial: "game/gameplay/player_hand/pre_round_hand",layout: false

  end

  #     5. REMOVE CARD FROM PLAYER HAND
  def remove_card_from_hand
    current_game_id = session[:game_id]

    card_id_to_remove = params[:remove_from_hand].gsub(/_selected/,'').to_i
    card_remove = CardGroup.where(game_id: current_game_id, user_id: current_user.id, card_id: card_id_to_remove).first
    card_remove.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false)

    @player_one_current_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)
    render partial: "game/gameplay/player_hand/pre_round_hand",layout: false
  end

  # ============================================
  #     6. UPDATE STATUS WINDOWS
  # ============================================
  def update_all_info_windows
    update_player_info
    update_opponent_info
    update_round_info
  end


  def update_player_info
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    @p1_current_health = current_game.p1_health
    @p1_health = ClassCard.find(params[:class_selected_id]).health
    @p1_current_energy = current_game.p1_energy

    logger.info "current_health: #{@p1_current_health}  total_health: #{@p1_health}"
    render partial: "game/gameplay/info_windows/player_info",layout: false
  end

  def update_opponent_info
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    @opponent_current_health = current_game.p2_health
    @opponent_health = ClassCard.find(params[:opponent_selected_id]).health
    @opponent_current_energy = current_game.p2_energy

    logger.info "opponent current_health: #{@opponent_current_health}  total_health: #{@opponent_health}"
    render partial: "game/gameplay/info_windows/opponent_info",layout: false
  end

  def update_round_info
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    @round_number = current_game.round

    if params[:new_game_start] == "true"
      @round_phase = "Setup"
    else
      case current_game.whose_turn
      when 11
        @round_phase = "Player attacking"
      when 12
        @round_phase = "Player defending"
      when 21
        @round_phase = "Opponent attacking"
      when 22
        @round_phase = "Opponent Defending"
      end
    end

    logger.info "@round_phase: #{@round_phase}"
    render partial: "game/gameplay/info_windows/round_info",layout: false
  end

  def start_round
    flash.now[:error] = "Starting the game!!!! "
    current_game_id = session[:game_id]
    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)

    current_game = Game.find(current_game_id)

    if current_game.whose_turn == 11
      render partial: "game/gameplay/player_hand/attack_round_hand", layout: false
    else
      flash.now[:error] = "Under attack!!!! "
      @opponent_attack_card = ai_attack_card(params[:opponent_selected_id])
      render partial: "game/gameplay/player_hand/defend_round_hand", layout: false
    end

  end

  def update_gameplay_middle
    @opponent_attack_card = params[:opponent_attack_card_id]
    render partial: "game/gameplay/info_windows/gameplay_middle", layout: false
  end


end
