module GameHelper


  #This populates the classes for a new game selection
  def get_card_class_list
    @class_cards = ClassCard.all
  end

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
