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

    success_message = t('views.preferences.destroy_success')
    failure_message = t('views.preferences.destroy_failure')

    if @preference.destroy!
      redirect_to preferences_path, notice: success_message, status: :see_other
    else
      handle_destroy_failure(failure_message)
    end
  rescue ActiveRecord::RecordNotDestroyed
    handle_destroy_failure(failure_message)
  end

  private

  def permitted_params
    params.require(:preference).permit(:name, :description, :restriction)
  end

  def handle_destroy_failure(failure_message)
    redirect_to preferences_path, alert: failure_message, status: :unprocessable_entity
  end
end
