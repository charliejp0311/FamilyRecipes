class RecipesController < ApplicationController

  # GET: /recipes
  get "/recipes" do
    if logged_in?
      erb :"/recipes/index.html"
    else
      redirect "/"
    end
  end

  # GET: /recipes/new
  get "/recipes/new" do
    if logged_in?
      erb :"/recipes/new.html"
    else
      redirect "/"
    end
  end

  # POST: /recipes
  post "/recipes" do
    if logged_in? 
      if !params["title"].empty? && !params["ingredients"].empty? && !params["cook_time"].empty?
        @recipe = Recipe.create(:title => params["title"], :ingredients => params["ingredients"], :cook_time => params["cook_time"])
        @recipe.user_id = current_user.id
        redirect "/recipes/#{@recipe.id}"
      else
        redirect "/recipes/new"
      end
    else
      redirect '/'
    end
  end

  # GET: /recipes/5
  get "/recipes/:id" do
    if logged_in?
      @recipe = Recipe.find_by_id(params["id"])
      @user = @recipe.user
      erb :"/recipes/show.html"
    else
      redirect '/'
    end
  end

  # GET: /recipes/5/edit
  get "/recipes/:id/edit" do
    erb :"/recipes/edit.html"
  end

  # PATCH: /recipes/5
  patch "/recipes/:id" do
    redirect "/recipes/:id"
  end

  # DELETE: /recipes/5/delete
  delete "/recipes/:id/delete" do
    redirect "/recipes"
  end
end
