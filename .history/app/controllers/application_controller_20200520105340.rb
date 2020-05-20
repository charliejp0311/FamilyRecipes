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
  # GET: /comments/5/edit
  get "/comments/:id/edit" do
    @comment = Comment.find_by_id(params["id"])
    if logged_in? && @comment.user = current_user
      erb :"/comments/edit.html"
    else
      redirect '/'
    end
  end
  
  # PATCH: /comments/5
  patch "/comments/:id" do
    if logged_in? && @comment.user = current_user
      @comment = Comment.find_by_id(params["id"])
      @comment.comment = params["comment"]
      @recipe = Recipe.find_by_id(@comment.recipe_id)
      redirect "/recipes/@recipe.id"
    else
      redirect "/"
    end
  end
  
    # DELETE: /comments/5/delete
  delete "/comments/:id/delete" do
    @comment = Comment.find_by_id(params["id"])
    if logged_in? && @comment.user = current_user
      @comment.destroy
      redirect "/recipes"
    else
      redirect "/recipes/#{@comment.recipe_id}"
    end
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
