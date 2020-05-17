class RecipesController < ApplicationController

  # GET: /recipes
  get "/recipes" do
    @recipes = Recipe.all
    if logged_in?
      @user = current_user
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
        @recipe.save
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
      @user = current_user
      @recipe = Recipe.find_by_id(params["id"])
      if @recipe.user == @user
        @author = @user
      else
        @author = @recipe.user
      end
      if @recipe.comments
        @comments = Comment.find_by(:recipe_id => @recipe.id)
        erb :'/recipes/show.html'
      else
        erb :'/recipes/show.html'
      end
    else
      redirect '/'
    end
  end

  # GET: /recipes/5/edit
  get "/recipes/:id/edit" do
    if logged_in?
      @recipe = Recipe.find_by_id(params["id"])
      if @recipe.user = current_user
        erb :"/recipes/edit.html"
      else
        redirect "/recipes/#{@recipe.id}"
      end
    else
      redirect '/'
    end
  end

  # PATCH: /recipes/5
  patch "/recipes/:id" do
    @recipe = Recipe.find_by_id(params["id"])
    if logged_in? && 
      if @recipe.user == current_user
        @user = current_user
        if !params["title"].empty? && !params["ingredients"].empty? && !params["cook_time"].empty?
          @recipe.title = params["title"]
          @recipe.ingredients = params["ingredients"]
          @recipe.cook_time = params["cook_time"]
          redirect "/recipes/#{@recipe.id}"
        else
          redirect "/recipes/#{@recipe.id}/edit"
        end
      else
        redirect "/recipes/#{@recipe.id}"
      end
    else
      redirect '/'
    end
  end

  # DELETE: /recipes/5/delete
  delete "/recipes/:id/delete" do
    @recipe = Recipe.find_by_id(params["id"])
    if logged_in? && @recipe.user = current_user
      @recipe.destroy
      redirect "/recipes"
    else
      redirect "/recipes/#{@recipe.id}"
    end
  end

  post "/recipes/:id/comment" do 
    @user = current_user
    @recipe = Recipe.find_by_id(params["id"])
    if !params["comment"].empty?
      @comment = Comment.create(:comment => params["comment"], :recipe_id => @recipe.id, :user_id => @user.id)
      redirect "/recipes/#{@recipe.id}"
    else
      redirect "/recipes/#{@recipe.id}"
    end

  end
end
