class RecipesController < ApplicationController

    def create
        user = User.find_by(id: session[:user_id])
        if user != nil
            recipe = Recipe.new(recipe_params)
            recipe.user_id = user.id
            if recipe.valid?
                recipe.save
                render json: recipe, include: :user, status: :created
            else
                render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: ['Unathorized']}, status: :unauthorized
        end
    end

    def index
        if session[:user_id] != nil
            recipes = Recipe.all
            render json: recipes, include: :user, status: :ok
        else
            render json: {errors: ['Unathorized']}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

end
