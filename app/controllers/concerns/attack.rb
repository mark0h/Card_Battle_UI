

module Attack
  extend ActiveSupport::Concern





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
