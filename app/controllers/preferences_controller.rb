# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def create
    @preference = PreferenceForm.new(args: preference_form_params)

    if @preference.valid?
      @preference.save!
      redirect_to preferences_path, notice: t('views.preferences.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

end
