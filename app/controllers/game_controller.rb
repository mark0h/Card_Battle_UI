class GameController < ApplicationController
  include CardInfo
  include MainMenu
  include PreRoundSetup
  include AiSetup
  include AiAttack

  def index
  end

  def show
  end

  def new
    # @class_cards = ClassCard.all
  end





end
