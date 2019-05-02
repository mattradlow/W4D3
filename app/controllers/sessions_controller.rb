class SessionsController < ApplicationController
    
    def new
        @user = User.new
        render :new
    end

    def create 
        user = User.find_by_credentials(params[:user][:user_name],params[:user][:password])
        if user
            login!(user) 
            # session[:session_token] = user.reset_session_token!
            redirect_to cats_url
        else 
            flash.new[:errors] = ["Invalid Username or Password"]
            render :new 
        end 
    end


    def destroy
        current_user = self.current_user 
        if current_user
            current_user.reset_session_token!
            session[:session_token] = nil 
            redirect_to cats_url
        end 
    end 
end