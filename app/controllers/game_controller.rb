class GameController < ApplicationController
  include CardInfo
  include MainMenu
  include GameplayMethods
  include PreRoundSetup
  include StatusEffects
  include Attack
  include Defend
  include AiSetup
  include AiAction
  include Barbarian

  def index
  end

  def show
  end

  def new
    # @class_cards = ClassCard.all
  end





end
