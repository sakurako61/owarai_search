class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user, :place)
  end
end
