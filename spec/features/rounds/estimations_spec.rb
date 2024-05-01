# frozen_string_literal: true

require 'rails_helper'

describe 'User can estimate tasks.', :js do
  let!(:round) { create(:round) }
  let!(:user) { create(:user) }
  let!(:current_task) { create(:task, round:, state:) }
  let(:state) { 'idle' }

  before do
    sign_in user
    visit round_path(round)
  end

  describe 'start task' do
    it 'changes task state to ongoing' do
      within("#task_#{current_task.id}") do
        expect do
          find('.start').click
          sleep(0.5)
        end
          .to change { find('.state').text }.from('idle').to('ongoing')
      end
    end

    it 'displays estimation panel' do
      expect { find(:css, "#task_#{current_task.id} .start").click }.to change {
        page.has_button?('1')
        page.has_button?('2')
        page.has_button?('3')
      }.from(false).to(true)
    end

    context 'when ongoing' do
      let(:state) { 'ongoing' }

      it 'changes task state to idle' do
        within("#task_#{current_task.id}") do
          expect do
            find('.start').click
            sleep(0.5)
          end.to change { find('.state').text }.from('ongoing').to('idle')
        end
      end

      it 'hides estimation panel' do
        expect do
          find(:css, "#task_#{current_task.id} .start").click
          sleep(0.5)
        end.to change {
          page.has_button?('1')
          page.has_button?('2')
          page.has_button?('3')
        }.from(true).to(false)
      end
    end
  end
end
