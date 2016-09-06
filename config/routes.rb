Rails.application.routes.draw do

  devise_for :users, :controllers => {:registrations => "user/registrations"}
  root 'main#menu'

  get 'class_card/index', to: 'class_card#index'
  resources :game, except: [:destroy, :edit, :update, :show]

  get 'game/get_class_info', to: 'game#get_class_info'
  get 'my_games', to: 'game#my_games'

  #  MAIN MENU BUTTON LINKS
  get '/game/new_game_render', to: 'game#new_game_render'
  get '/game/intro_page_render', to: 'game#intro_page_render'
  get '/game/my_profile', to: 'game#my_profile'
  get '/game/my_games', to: 'game#my_games'


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
