class CommentsController < ApplicationController

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


end
