# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_round, only: %i[show edit update destroy]

  def index
    @round = Round.ordered
  end

  def show; end

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

  def round_params
    params.require(:round).permit(:title)
  end
end
