module MainMenu
  extend ActiveSupport::Concern

  # ------------------------------
  #    MAIN MENU METHODS
  # ------------------------------
  def new_game_render
    render "game/_new_game",
         locals: { obj: "variable" },
         layout: false
  end

  def intro_page_render
    render "game/_start_display",
         locals: { obj: "variable" },
         layout: false
  end

  def my_profile
    render "devise/registrations/edit",
         locals: { obj: "variable" },
         layout: false
  end

  def my_games
    render "user/_my_games",
         locals: { obj: "variable" },
         layout: false
  end


end
