module GameHelper


  #This populates the classes for a new game selection
  def get_card_class_list
    @class_cards = ClassCard.all
  end

end
