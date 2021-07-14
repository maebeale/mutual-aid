# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  devise_for :users

  scope '/admin' do
    root to: 'admin_dashboard#show', as: 'admin_dashboard'

    resource :volunteers,     only: [:show], controller: :volunteer_admin, as: 'volunteer_admin'
    resource :dispatch_steps, only: [:show]
    resource :yearbook,       only: [:show], controller: :yearbook
  end

  get '/public',                   to: 'public_pages#landing_page',        as: 'landing_page_public'
  get '/about',                    to: 'public_pages#about',               as: 'about_public'
  get '/version',                  to: 'public_pages#version',             as: 'version'

  resources :announcements
  resources :asks, only: %i[index edit update new create]
  resources :categories
  resources :communication_logs do
    collection do
      post '/create_remote', to: 'communication_logs#create_remote', as: 'create_remote'
    end
  end
  resources :community_resources
  resources :contact_methods
  resource :thank_you, only: %i[show], controller: :thank_you
  resources :contributions, except: %i[destroy] do
    resources :claims, only: %i[new create]
  end
  resources :custom_form_questions
  resources :donations
  resources :feedbacks
  resources :forms
  resources :form_questions
  resources :history_logs, only: [:index]
  resources :location_types
  resources :listings do
    member do
      get '/match', to: 'listings#match', as: 'match_listing'
      post '/match', to: 'listings#match'
      get '/match/confirm', to: 'listings#match_confirm', as: 'match_confirm_listing'
      post '/match/confirm', to: 'listings#match_confirm'
    end
  end
  resources :locations
  resources :matches
  resources :mobility_string_translations
  resources :offers, only: %i[index edit update new create]
  get '/org_chart', to: 'organizations#org_chart', as: 'org_chart'
  resources :organizations
  resources :people
  resources :positions
  resources :service_areas
  resources :shared_accounts
  resources :shifts
  resources :shift_matches
  resources :software_feedbacks
  resources :submissions
  resources :submission_responses
  resources :submission_response_imports, only: %i[new create]
  resources :system_locales
  resources :system_settings
  resources :teams
  resources :users

  resource :glossary, controller: :glossary, only: [:show, :edit, :update]

  root to: 'public_pages#landing_page'
end
