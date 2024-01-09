# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'rounds#index'

  resources :rounds, only: %i[index show] do
    resources :tasks, shallow: true do
      post :start, on: :member
      post :stop, on: :member
    end
  end
end
