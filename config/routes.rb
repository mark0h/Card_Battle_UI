Rails.application.routes.draw do

  devise_for :users, :controllers => {:registrations => "user/registrations"}
  root 'game#index'

  get 'class_card/index', to: 'class_card#index'
  resources :game, except: [:destroy, :edit, :update, :show]

  get 'game/get_class_info', to: 'game#get_class_info'
  get 'game/get_opponent_info', to: 'game#get_opponent_info'
  get 'my_games', to: 'game#my_games'

  #  MAIN MENU BUTTON LINKS
  get '/game/new_game_render', to: 'game#new_game_render'
  get '/game/intro_page_render', to: 'game#intro_page_render'
  get '/game/my_profile', to: 'game#my_profile'
  get '/game/my_games', to: 'game#my_games'

  #NEW GAME CLASS selection
  get '/game/selected_class_cards', to: 'game#selected_class_cards'
  get '/game/opponent_class_cards', to: 'game#opponent_class_cards'

  #PLAY GAME WINDOW
  get '/game/setup_new_game', to: 'game#setup_new_game'
  get '/game/setup_ai_play_hand', to: 'game#setup_ai_play_hand'
  get '/game/get_current_deck', to: 'game#get_current_deck'
  get '/game/add_card_to_hand', to: 'game#add_card_to_hand'
  get '/game/remove_card_from_hand', to: 'game#remove_card_from_hand'
  get '/game/start_round', to: 'game#start_round'

  # PLAY GAME STATUS WINDOW
  get '/game/update_player_info', to: 'game#update_player_info'
  get '/game/update_opponent_info', to: 'game#update_opponent_info'
  get '/game/update_round_info', to: 'game#update_round_info'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
