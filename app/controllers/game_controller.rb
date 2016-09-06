class GameController < ApplicationController
  include CardInfo

  def index
  end

  def show
  end

  def new
    @class_cards = ClassCard.all
  end

end
