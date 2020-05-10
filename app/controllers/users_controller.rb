class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    if logged_in?
      @user = User.find_by_id(session[:id])
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
    @user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
    session[:id] = @user.id
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
