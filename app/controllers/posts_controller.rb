class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:user, :place)
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: '投稿を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:live_name, :discription, :start_date, :end_date,
                                  :open_date, :price, :live_url, :ticket_start_date,
                                  :ticket_end_date, :place_id, :live_poster)
  end
end
