# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def new
    @preference = Preference.new
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  def create
    @preference = current_user.preferences.new(permitted_params)

    if @preference.save
      redirect_to preferences_path, notice: t('views.preferences.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @preference = Preference.find(params[:id])
    if @preference.update(permitted_params)
      redirect_to preferences_path, notice: t('views.users.update_success')
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private

  def permitted_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
