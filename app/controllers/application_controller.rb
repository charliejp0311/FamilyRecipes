require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions unless test?
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
    set :method_override, true
  end

  get "/" do
    erb :welcome
  end
  
  # POST: /login this is from the welcome page the only place to sign in besides when you create a user
  post "/login" do
    if !params["username"].empty? && !params["password"].empty?
      @user = User.find_by_username(params["username"])
      if @user && @user.authenticate(params["password"])
        session[:id] = @user.id
        redirect "/users/#{@user.id}"
      else
        redirect '/'
      end
    else
      redirect '/'
    end
  end
  get '/logout' do
    session.clear
    redirect to '/'
  end
  #shortcuts for login status to prevent writing the same code over and over
  helpers do
		def logged_in?
			!!session[:id]
		end

		def current_user
			User.find(session[:id])
		end
	end
end
