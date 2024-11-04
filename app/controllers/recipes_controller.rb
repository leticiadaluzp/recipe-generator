# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes
  end

  def show
    @recipe = current_user.recipes.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = RecipeGeneratorService.new(permitted_params[:ingredients], current_user.id).call
    if @recipe.valid?
      redirect_to recipes_path, notice: t('views.recipes.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  rescue RecipeGeneratorServiceError => exception
    redirect_to recipes_path, alert: exception.message
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      redirect_to recipes_path, notice: t('views.recipes.destroy_success')
    else
      redirect_to recipes_path, alert: t('views.recipes.destroy_failure'), status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:recipe).permit(:ingredients)
  end
end
