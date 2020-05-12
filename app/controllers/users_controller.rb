class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    if logged_in?
      @user = current_user
      @recipes = @user.recipes 
      erb :"/users/index.html"
    else
      redirect '/welcome'
    end
  end
  
  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    if logged_in?
      redirect "/users/#{session[:id]}"
    else
      @user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
      session[:id] = @user.id
      redirect "/users/#{@user.id}"
    end
  end

  # GET: /users/5
  get "/users/:id" do
    if logged_in?
      @user = User.find_by_id(params[:id])
      erb :"/users/show.html"
    else
      redirect "/welcome"
    end
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    if session[:id] == params["id"]
      @user = current_user
      erb :"/users/edit.html"
    else
      redirect '/users'
    end
  end

  # PATCH: /users/5
  patch "/users/:id" do
    if current_user.id == params["id"]
      @user = User.find_by_id(params["id"])
      if !params["email"].empty?
        @user.eamil = params["email"]
      end
      if !params["password"].empty?
        @user.password = params["password"]
      end
      redirect "/users/:id"      
    end
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    if current_user.id == params["id"]
      current_user.destroy
      redirect '/users/new'
    else
      redirect "/users"
    end
  end

end