module PlayGame
  extend ActiveSupport::Concern


  def setup_new_game
    @player_one_class = ClassCard.find(params[:class_selected_id])
    @opponent_class = ClassCard.find(params[:opponent_selected_id])
    @player_one_health = @player_one_class.health
    @player_one_energy = 1

    @player_one_current_deck = SkillCard.where(class_id: params[:class_selected_id])


    new_game = Game.where(whose_turn: 1, p1_health: @player_one_health, p2_health: @player_one_health, round: 1, user_id: current_user.id, opponent_id: 0).first_or_create

    #Add all cards as deck cards to CardGroup
    @player_one_current_deck.each do |card|
      d_card = CardGroup.where(game_id: new_game.id, card_id: card.id).first_or_create
      d_card.update(cooldown_remaining: 0, current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false, image_path: card.image_path)
      d_card.save
    end

    session[:game_id] = new_game.id

    render "game/gameplay/_play_game",
         layout: false

  end

  def get_current_deck
    current_game_id = session[:game_id]
    @player_one_current_deck = CardGroup.where(game_id: current_game_id, deck_card: true)
    render partial: 'game/gameplay/player_deck', layout: false
  end


  # ============================================
  #    CALLED WHEN PLAYER CLICKS ON A CARD IN HIS DECK
  # ============================================
  def add_card_to_hand
    current_game_id = session[:game_id]

    #SET up the instance variables used in the partials to render the different cards
    @player_one_current_hand = CardGroup.where(game_id: current_game_id, current_hand_card: true)

    #First verify there is room in the current hand to add another card, if so, change that card_id current_hand value to true and deck_card to false
    if @player_one_current_hand.length > 2
      flash.now[:error] = "You must remove a card from your hand first! Can only have 3 cards "
    else
      card_id_to_add = params[:add_to_hand].gsub(/_selected/,'').to_i
      card_add = CardGroup.where(game_id: current_game_id, card_id: card_id_to_add).first
      card_add.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)

    end

    @player_one_current_hand = CardGroup.where(game_id: current_game_id, current_hand_card: true)
    render partial: "game/gameplay/player_current_hand",layout: false

  end

  def remove_card_from_hand
    current_game_id = session[:game_id]

    card_id_to_remove = params[:remove_from_hand].gsub(/_selected/,'').to_i
    card_remove = CardGroup.where(game_id: current_game_id, card_id: card_id_to_remove).first
    card_remove.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false)

    @player_one_current_hand = CardGroup.where(game_id: current_game_id, current_hand_card: true)
    render partial: "game/gameplay/player_current_hand",layout: false
  end

  def update_player_info
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)
    @p1_current_health = current_game.p1_health
    @p1_health = ClassCard.find(params[:class_selected_id]).health
    logger.info "current_health: #{@p1_current_health}  total_health: #{@p1_health}"
    render partial: "game/gameplay/player_info",layout: false
  end


end
