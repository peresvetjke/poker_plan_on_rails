# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage tasks list.', js: true do
  let!(:round) { create(:round, :with_tasks) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:task_title) { 'My first task' }

  describe 'create' do
    it 'allows to create saves task', aggregate_failures: true do
      sign_in user
      visit round_path(round)
      click_on 'New task'
      fill_in 'task_title', with: task_title
      click_on 'Save'
      expect(page).to have_content(task_title)
      visit round_path(round)
      expect(page).to have_content(task_title)
    end

    it 'streams new task to other users' do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit round_path(round)
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit round_path(round)
        click_on 'New task'
        fill_in 'task_title', with: task_title
        click_on 'Save'
      end
      using_session 'other_user' do
        expect(page).to have_content(task_title)
      end
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

    it 'streams updates to other users' do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit round_path(round)
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit round_path(round)
        click_on 'Edit', match: :first
        fill_in 'task_title', with: task_title
        click_on 'Save'
      end
      using_session 'other_user' do
        expect(page).to have_content(task_title)
      end
    end
  end

  describe 'destroy' do
    let(:task_title) { round.tasks.first.title }

    it 'allows do destroy tasks', aggregate_failures: true do
      sign_in user
      visit round_path(round)
      expect(page).to have_selector('.task', count: 2)
      click_on 'Delete', match: :first
      expect(page).to have_selector('.task', count: 1)
    end

    it 'streams updates to other users', aggregate_failures: true do # rubocop:disable RSpec/ExampleLength
      using_session 'other_user' do
        sign_in other_user
        visit round_path(round)
        expect(page).to have_selector('.task', count: 2)
        sleep 0.5
      end
      using_session 'user' do
        sign_in user
        visit round_path(round)
        click_on 'Delete', match: :first
      end
      using_session 'other_user' do
        expect(page).to have_selector('.task', count: 1)
      end
    end
  end
end
