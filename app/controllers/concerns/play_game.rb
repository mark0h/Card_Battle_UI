module PlayGame
  extend ActiveSupport::Concern

  @player_one_id
  @player_one_class
  @player_one_health
  @player_one_energy


  def setup_new_game
    @player_one_id = current_user.id
    @player_one_class = ClassCard.find(params[:class_selected_id])
    @player_one_health = @player_one_class.health
    @player_one_energy = 1

    @class_deck = SkillCard.where(class_id: params[:class_selected_id])

    @game_turn = 1

    render "game/_play_game",
         layout: false
  end


end
