# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_round, only: %i[show edit update destroy]
  before_action :set_current_task, only: %i[show]
  # before_action :set_current_estimation, only: %i[show]

  def index
    @rounds = Round.ordered
  end

  def show
    RoundUser.find_or_create_by(user_id: current_user.id, round_id: @round.id)
  end

  def new
    @round = Round.new
  end

  def edit; end

  def create
    @round = Round.new(round_params)

    if @round.save
      message = 'Round was successfully created.'
      respond_to do |format|
        format.html { redirect_to rounds_path, notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @round.update(round_params)
      message = 'Round was successfully updated.'
      respond_to do |format|
        format.html { redirect_to rounds_path, notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @round.destroy

    message = 'Round was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to rounds_path, notice: message }
      format.turbo_stream { flash.now[:notice] = message }
    end
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end

  def set_current_task
    @current_task = @round.current_task
  end

  def set_users
    @users = @round.users
  end

  # def set_current_estimation
  #   @current_estimation = Estimation.find_by(task_id: @current_task.id, user_id: current_user.id)
  # end

  # def set_estimations_status
  #   estimations = Estimation.where(task_id: @current_task.id)
  #   @users..map do |e|
  #     [e.id, e.value.present?]
  #   end
  #   @estimations_status = @round.current_task
  # end

  def round_params
    params.require(:round).permit(:title)
  end
end
