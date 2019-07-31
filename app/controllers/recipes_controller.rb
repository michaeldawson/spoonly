# Fetch and display recipe information to users
class RecipesController < ApplicationController
  def index
    @recipes = ContentfulAPI::RecipeFetcher.all_recipes
  end

  def show
    @recipe = ContentfulAPI::RecipeFetcher.recipe(params[:id])
    raise "Derp" unless @recipe
  end
end
