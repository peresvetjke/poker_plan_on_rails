# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'rounds#index'

  resources :rounds do
    resources :tasks, shallow: true do
      get 'finished', on: :collection
    end
  end

  post 'tasks/:id/start',    to: 'tasks#start', as: 'start_task'
  post 'tasks/:id/estimate', to: 'tasks#estimate',  as: 'estimate_task'
  get  'tasks/:id/results',  to: 'tasks#results', as: 'task_results'

  resources :round_users, only: %i[destroy]
end
