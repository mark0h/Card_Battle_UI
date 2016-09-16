module GameHelper


  #This populates the classes for a new game selection
  def get_card_class_list
    @class_cards = ClassCard.all
  end

  def get_my_games
    @player_games = Game.where(user_id: current_user.id)
  end

  


  # -------------------------------
  #  The following 4 methods are for the DEVISE render pages
  # -------------------------------
  def resource_name
    :user
  end

  def resource
    @resource ||= current_user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end

end
