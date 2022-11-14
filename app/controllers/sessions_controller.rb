class SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :accepted
        else
            render json: {errors: ['Invalid username or password']}, status: :unauthorized
        end
    end

    def destroy
        user = User.find_by(id: session[:user_id])
        if user
            user.destroy
            session[:user_id] = nil
            head :no_content
        else
            render json: {errors: ['Unauthorized']}, status: :unauthorized
        end
    end
end