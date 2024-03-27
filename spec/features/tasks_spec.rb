# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage tasks list.', :js do
  let!(:round) { create(:round, :with_tasks) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:task_title) { 'My first task' }

  describe 'create' do
    it 'allows to create saves task', :aggregate_failures do
      sign_in user
      visit round_path(round)
      click_on 'New task'
      fill_in 'task_title', with: task_title
      click_on 'Save'
      expect(page).to have_content(task_title)
      visit round_path(round)
      expect(page).to have_content(task_title)
    end

    it 'streams new task to other users' do
      sign_in other_user
      visit round_path(round)
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit round_path(round)
        click_on 'New task'
        fill_in 'task_title', with: task_title
        click_on 'Save'
      end

      expect(page).to have_content(task_title)
    end
  end

  describe 'update' do
    it 'allows to update tasks' do
      sign_in user
      visit round_path(round)
      click_on 'Edit', match: :first
      fill_in 'task_title', with: task_title
      click_on 'Save'
      expect(page).to have_content(task_title)
    end

    it 'streams updates to other users' do
      sign_in other_user
      visit round_path(round)
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit round_path(round)
        click_on 'Edit', match: :first
        fill_in 'task_title', with: task_title
        click_on 'Save'
      end

      expect(page).to have_content(task_title)
    end
  end

  describe 'destroy' do
    let(:task_title) { round.tasks.first.title }

    it 'allows do destroy tasks', :aggregate_failures do
      sign_in user
      visit round_path(round)
      expect(page).to have_css('.task', count: 2)
      within("#task_#{round.tasks.first.id}") { click_on 'Delete' }
      expect(page).to have_css('.task', count: 1)
    end

    it 'streams updates to other users', :aggregate_failures do
      sign_in other_user
      visit round_path(round)
      expect(page).to have_css('.task', count: 2)
      sleep 0.5

      using_session 'user' do
        sign_in user
        visit round_path(round)
        within("#task_#{round.tasks.first.id}") { click_on 'Delete' }
      end

      expect(page).to have_css('.task', count: 1)
    end
  end
end
