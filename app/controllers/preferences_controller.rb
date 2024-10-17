# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def show
    @preference = Preference.find(params[:id])
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = current_user.preferences.new(permitted_params)

    if @preference.save
      redirect_to preferences_path, notice: t('views.preferences.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    if @preference.destroy!
      redirect_to preferences_path, notice: t('views.preferences.destroy_success'), status: :see_other
    else
      redirect_to preferences_path, alert: t('views.preferences.destroy_failure'), status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
