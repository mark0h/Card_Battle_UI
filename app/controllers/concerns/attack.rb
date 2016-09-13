

module Attack
  extend ActiveSupport::Concern

  def start_attack
    current_game_id = session[:game_id]
    @player_one_play_hand = CardGroup.where(game_id: current_game_id, user_id: current_user.id, current_hand_card: true)
    render partial: "game/gameplay/player_hand/attack_round_hand", layout: false
  end





  def attack_update_round_info
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)
    @whose_turn = Game.find(current_game_id).first.whose_turn

    @round_phase = "Setup"
    # @player_turn = "Your turn"
    # @player_turn = "Opponent's turn" #if current_game.whose_turn == 2
    render partial: "game/gameplay/info_windows/round_info",layout: false
  end

end
