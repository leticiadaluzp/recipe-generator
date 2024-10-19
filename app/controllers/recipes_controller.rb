# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new()

    if @recipe.save
      redirect_to recipes_path, notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end
end
