class CommentsController < ApplicationController

  # GET: /comments/5/edit
  get "/comments/:id/edit" do
    erb :"/comments/edit.html"
  end

  # PATCH: /comments/5
  patch "/comments/:id" do
    redirect "/comments/:id"
  end

  # DELETE: /comments/5/delete
  delete "/comments/:id/delete" do
    redirect "/comments"
  end

end
