class RecipesController < ApplicationController

  # GET: /recipes
  get "/recipes" do
    @recipes = Recipe.all
    @comments = {}
    @recipes.each do |recipe|
      @comments[recipe] = Comment.find_by(:recipe_id => recipe.id)
    end
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
      @comments = []
      cmts = Comment.all
      cmts.each do |c|
        if c.recipe_id == @recipe.id 
          @comments << c
        end
      end
      if @recipe.user == @user
        @author = @user.username 
      else
        @author = @recipe.user.username
      end
      erb :'/recipes/show.html'
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
          @recipe.save
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

  get '/recipes/:id/delete' do
    if logged_in? && Recipe.find_by_id(params[:id]).user == current_user
      Recipe.find_by_id(params[:id]).destroy
      redirect '/recipes'
    end
  end

  # # DELETE: /recipes/5/delete
  # delete "/recipes/:id/delete" do
  #   @recipe = Recipe.find_by_id(params["id"])
  #   @user = current_user
  #   binding.pry
  #   if logged_in? && @recipe.user = @user
  #     @recipe.destroy
  #     redirect "/recipes"
  #   else
  #     redirect "/recipes/#{@recipe.id}"
  #   end
  # end

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
