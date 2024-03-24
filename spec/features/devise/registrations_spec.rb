# frozen_string_literal: true

require 'rails_helper'

describe 'User can register.', :js do
  let(:user) { create(:user, email: 'user1@example.com', username: 'username1', password: 'password') }

  describe 'sign_up' do
    before do
      visit new_user_registration_path
      fill_in 'Email', with: 'user1@example.com'
      fill_in 'Username', with: 'username1'
      fill_in 'Password', with: 'my_password'
      fill_in 'Password confirmation', with: 'my_password'
    end

    it 'allows user to register' do
      click_on 'Sign up'
      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  describe 'edit user registration' do
    before do
      sign_in user
      visit rounds_path
    end

    it 'allows user to update user record', :aggregate_failures do
      click_link_or_button user.email
      fill_in 'Username', with: 'username2'
      fill_in 'Current password', with: 'password'
      click_link_or_button 'Update'
      expect(page).to have_content('Your account has been updated successfully.')
      click_link_or_button user.email
      expect(page).to have_field('Username', with: 'username2')
    end
  end
end
