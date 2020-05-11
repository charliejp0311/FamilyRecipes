require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions unless test?
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end
  
  # POST: /login
  post "/login" do
    if !params["username"].empty? && !params["password"].empty?
      @user = User.find_by_username(params["username"])
      if @user.password == @user.authenticate(params["password"])
        session[:id] = @user.id
        redirect '/users/<%=@user.id%>'
      else
        redirect '/'
      end
    else
      redirect '/'
    end
  end

  helpers do
		def logged_in?
			!!session[:id]
		end

		def current_user
			User.find(session[:id])
		end
	end
end
