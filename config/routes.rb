Rails.application.routes.draw do
  namespace :admin do
    root to: "application#index"
    resources :posts do
      member do
        delete :remove_tag
        patch :toggle_status
      end
    end
  end

  resources :posts do
    resources :comments, only: %i(create)
  end

  resources :comments do
    resources :comments, only: %i(create)
  end

  get ":date/:slug", to: "home#post", as: :post_detail,
                     constraints: { :date => /\d{4}-\d{2}-\d{2}/ }

  get "author/:id/:name", to: "home#author_posts", as: :author, constraints: { :id => /\d+/ }

  devise_for :users
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  authenticate :user do
    resources :subscriptions, only: :update
  end
end
