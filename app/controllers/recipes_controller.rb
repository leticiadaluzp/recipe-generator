# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes
  end

  def new
    @recipe = Recipe.new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    recipe_generator = RecipeGeneratorService.new(permitted_params[:ingredients], current_user.id).call

    if recipe_generator
      redirect_to recipes_path, notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:recipe).permit(:ingredients)
  end
end
