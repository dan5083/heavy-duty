Rails.application.routes.draw do
  devise_for :users

  # ✅ Nested workout logging structure with recovery seeding routes
  resources :split_plans, only: [:index, :new, :create, :destroy] do
    member do
      get :initialize_recovery
      post :submit_recovery
    end

    resources :split_days, only: [:edit, :update] do
      resources :workouts, only: [:new, :create, :update, :destroy, :show] do
        post :promote, on: :member
        resources :workout_logs, only: [:new, :create, :index] do
          collection do
            post :render_set_inputs # 🆕 Turbo step 2 handler
          end
        end
      end
    end
  end

  # ✅ Dashboard and archive
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "archive", to: "training_archive#index", as: :training_archive

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # ✅ Root
  root "dashboard#index"
end
