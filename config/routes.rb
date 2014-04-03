require 'sidekiq/web'

IHeartPsychics::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {
                        omniauth_callbacks: 'omniauth_callbacks',
                        registrations: "registrations",
                        sessions: "sessions",
                        passwords: "passwords" }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    resource :admin
    resource :dashboard
    resources :accountants
    resources :call_surveys

    resources :calls do
      member do
        post :refund
      end

      collection do
        get :summary
      end
    end

    resources :categories
    resources :psychic_faq_categories

    resources :clients do
      member do
        get :resend_confirmation
      end
    end

    resources :customer_service_representatives
    resources :daily_fortunes, except: :show
    resources :horoscopes

    resources :invoices, only: :show do
      resources :payments

      collection do
        get 'paid', action: :paid, as: :paid
        get 'pending', action: :pending, as: :pending
      end
    end

    resources :manager_directors

    resources :newsletters do
      member do
        get 'deliver', action: :deliver, as: :deliver
        get 'reset'  , action: :reset  , as: :reset
      end
    end

    resources :orders, :except => [:edit, :update, :destroy] do
      resource :refunds, :only => :create
    end

    resources :packages
    resources :psychic_applications

    resources :psychics do
      member do
        get 'available'  , action: :available  , as: :available
        get 'disable'    , action: :disable    , as: :disable
        get 'unavailable', action: :unavailable, as: :unavailable
      end
    end

    resources :reviews, :shallow => true do
      member do
        get 'mark_as_featured', action: :mark_as_featured, as: :mark_as_featured
        get 'unmark_as_featured', action: :unmark_as_featured, as: :unmark_as_featured
      end
    end

    resources :schedule_jobs, :only => [:index, :edit, :update]
    resources :surveys
    resources :subscribers
    resources :website_admins

    get "/debug", to: "debug#index"
  end

  namespace :calls do
    resources :psychic_callbacks
    resources :client_callbacks
  end

  resources :calls do
    collection do
      post 'notify(:.format)'         , action: :notify
      get  'notify(:.format)'         , action: :notify
      post 'user(:.format)'           , action: :user
      get  'user(:.format)'           , action: :user
      post 'pin(:.format)'            , action: :pin
      get  'pin(:.format)'            , action: :pin
      post 'transfer(:.format)'       , action: :transfer
      get  'transfer(:.format)'       , action: :transfer
      post 'do_transfer(:.format)'    , action: :do_transfer
      get  'do_transfer(:.format)'    , action: :do_transfer
      post 'topup(:.format)'          , action: :topup
      get  'topup(:.format)'          , action: :topup
      post 'buy_credits(.:format)'    , action: :buy_credits
      get  'buy_credits(.:format)'    , action: :buy_credits
      post 'confirm_credits(:.format)'  , action: :confirm_credits
      get  'confirm_credits(:.format)'  , action: :confirm_credits
      post 'call_finished(:.format)'  , action: :call_finished
      get  'call_finished(:.format)'  , action: :call_finished
    end
  end

  resource :client, :except => :create do
    resources :client_phones
    member do
      get     'reset_pin'       , action: :reset_pin, as: :reset_pin
      patch   'reset_pin'       , action: :reset_pin
      get     'add_credits'     , action: :add_credits, as: :add_credits
      patch   'add_credits'     , action: :add_credits
      get     'make_favorite'   , action: :make_favorite, as: :make_favorite
      get     'remove_favorite' , action: :remove_favorite, as: :remove_favorite
      patch   '/:id/avatar'     , action: :avatar, as: :avatar
      delete  'delete_card'     , action: :destroy_card, as: :destroy_card
    end
  end

  resource :psychic, :except => :create do
    resources :reviews, only: [], shallow: true do
      member do
        get 'mark_as_featured'   , action: :mark_as_featured   , as: :mark_as_featured
        get 'unmark_as_featured' , action: :unmark_as_featured , as: :unmark_as_featured
      end
    end

    resources :invoices
    resources :schedules

    collection do
      get 'search', action: :search, as: :search
    end

    member do
      get   'available'   , action: :available    , as: :available
      get   'unavailable' , action: :unavailable  , as: :unavailable
      get   '/:id/about'  , action: :about        , as: :about
      patch '/:id/avatar' , action: :avatar       , as: :avatar
    end
  end

  resource :callbacks
  resource :customer_service_representative
  resource :accountant

  resources :orders do
    collection do
      post 'paypal', action: :paypal, as: :paypal
    end
  end
  resources :psychic_applications do
    collection do
      get 'confirmation', action: :confirmation, as: :confirmation
    end
  end

  resources :surveys do
    member do
      post 'answer' , action: :answer, as: :answer
    end
  end

  resources :subscribers
  resources :messages
  resources :applications
  resources :horoscopes, only: :index
  resources :training_items

  get "/psychics/faqs", to: "psychic_faqs#index", as: "psychic_faqs"
  resources :faqs

  post "/paypal/callback" , to: "paypal#callback" , as: "paypal_callback"
  post "/paypal/success"  , to: "paypal#success"  , as: "paypal_success"
  get  "/paypal/cancel"   , to: "paypal#cancel"   , as: "paypal_cancel"

  get "/dashboard", to: "home#show", as: "dashboard"
  get "/unsubscribe/:id", to: "unsubscribe#unsubscribe", as: "unsubscribe"

  get "/apna", to: "home#apna", as: "apna"
  get "/careers", to: "home#careers", as: "careers"
  get "/contact", to: "home#contact", as: "contact"
  get "/dictionary", to: "home#dictionary", as: "dictionary"
  get "/email_confirmation", to: "home#confirmation", as: "email_confirmation"
  get "/ethics", to: "home#ethics", as: "ethics"
  get "/how_it_works", to: "home#how_it_works", as: "how_it_works"
  get "/privacy", to: "home#privacy", as: "privacy"
  get "/terms", to: "home#terms", as: "terms"

  pulse "/pulse"

  get "/" => "home#staff", constraints: { subdomain: "admin" }
  get "/" => "home#staff", constraints: { subdomain: "staff" }
  root to: 'home#index'
end
