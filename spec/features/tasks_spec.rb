# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage tasks list.', js: true do
  let!(:user) { create(:user) }
  let!(:round) { create(:round, :with_tasks) }
  let(:tasks) { round.tasks }

  before do
    sign_in user
    visit round_path(round)
  end

  describe 'index' do
    it 'displays tasks list' do
      tasks.each do |task|
        expect(page).to have_content(task.title)
      end
    end
  end

  describe 'create' do
    it 'allows to create new tasks' do
      binding.irb
      click_on('New task')
    end
  end
end
