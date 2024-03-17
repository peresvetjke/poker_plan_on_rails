# frozen_string_literal: true

class RoundUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_round_user, only: %i[destroy]

  def destroy
    @round_user.destroy

    message = 'User was successfully kicked.'
    respond_to do |format|
      format.html { redirect_to round_path(@round_user.round_id), notice: message }
      format.turbo_stream { flash.now[:notice] = message }
    end
  end

  private

  def set_round_user
    @round_user = RoundUser.find(params[:id])
  end
end
