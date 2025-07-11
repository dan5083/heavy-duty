# config/routes.rb
Rails.application.routes.draw do
  # Use custom registration controller
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # NEW: Impersonation routes
  post '/impersonate/:id', to: 'impersonation#start', as: :start_impersonation
  delete '/stop_impersonation', to: 'impersonation#stop', as: :stop_impersonation

  # Personal trainer management
  resources :personal_trainers, only: [:show] do
    resources :client_assignments, only: [:create, :destroy]
  end

  # Nested workout logging structure with recovery seeding routes
  # FIXED: Added :show to allow split_plan_path(plan) to work with DELETE method
  # Note: :show route needed for path helper, but no controller action/view required
  resources :split_plans, only: [:index, :new, :create, :show, :destroy] do
    member do
      get :initialize_recovery
      post :submit_recovery
    end
    collection do
      # Custom split routes
      get :build_custom
      post :create_custom
    end
    resources :split_days, only: [:edit, :update] do
      resources :workouts, only: [:new, :create, :update, :destroy, :show] do
        post :promote, on: :member
        resources :workout_logs, only: [:new, :create, :index] do
          collection do
            post :render_set_inputs # Turbo step 2 handler
          end
        end
      end
    end
  end

  # === SIMPLIFIED: Single dashboard route ===
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Archive routes (unchanged)
  get "archive", to: "training_archive#index", as: :training_archive

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "dashboard#index"

  # PWA routes
  get '/manifest.json', to: 'pwa#manifest'
  get '/service-worker.js', to: 'pwa#service_worker'
end
