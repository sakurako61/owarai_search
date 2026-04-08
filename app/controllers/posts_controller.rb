class PostsController < ApplicationController
  before_action :set_post, :set_master_data, only: %i[show edit destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user, :place)
  end

  def new
    @post             = Post.new(session[:confirm_post_params] || {})
    @performer_names  = session[:confirm_performer_names] || []
    @poster_filename  = session[:confirm_poster_filename]
    @poster_signed_id = session[:confirm_poster_signed_id]
    @places           = Place.order(:name)
  end

  def confirm
    if request.post?
      if params[:post_id].present?
        # 編集
        @post = current_user.posts.find(params[:post_id])
        @post.assign_attributes(post_params)
      else
        # 新規
        @post = Post.new(post_params)
        @post.user = current_user
      end

      @performer_names = params[:performer_names]&.reject(&:blank?) || []

      unless @post.valid?
        @places = Place.order(:name)
        render(session[:confirm_post_id].present? ? :edit : :new, status: :unprocessable_entity)
        return
      end

      # session保存（共通）
      session[:confirm_post_params]     = post_params.to_h
      session[:confirm_performer_names] = @performer_names
      session[:confirm_post_id]         = params[:post_id]

      # 画像をBlobとして保存しsigned_idをセッションに保持
      poster_file = params[:post][:poster]
      if poster_file.present?
        blob = ActiveStorage::Blob.create_and_upload!(
          io: poster_file,
          filename: poster_file.original_filename,
          content_type: poster_file.content_type
        )
        session[:confirm_poster_signed_id] = blob.signed_id
        session[:confirm_poster_filename]  = blob.filename.to_s
        session[:confirm_remove_poster]    = false
      elsif params[:remove_poster] == "1"
        session[:confirm_remove_poster]    = true
        session.delete(:confirm_poster_signed_id)
        session.delete(:confirm_poster_filename)
      end

      redirect_to confirm_posts_path, status: :see_other

    else
      # GET
      if session[:confirm_post_id]
        @post = current_user.posts.find(session[:confirm_post_id])
        @post.assign_attributes(session[:confirm_post_params])
      else
        @post = Post.new(session[:confirm_post_params] || {})
      end

      @performer_names   = session[:confirm_performer_names] || []
      @poster_signed_id  = session[:confirm_poster_signed_id]
      @poster_filename   = session[:confirm_poster_filename]
      @remove_poster     = session[:confirm_remove_poster]
      @place = Place.find_by(id: @post.place_id)

      render :confirm
    end
  end

  def create
    if session[:confirm_post_id].present?
      # 🔥 update処理
      @post = current_user.posts.find(session[:confirm_post_id])
      @post.assign_attributes(post_params)
    else
      # 🔥 create処理
      @post = Post.new(post_params)
      @post.user = current_user
    end

    if params[:poster_signed_id].present?
      @post.live_poster.attach(params[:poster_signed_id])
    elsif params[:remove_poster] == "1"
      @post.live_poster.purge
    end

    if @post.save
      performer_names = params[:performer_names]&.reject(&:blank?) || []

      @post.performers.destroy_all
      performer_names.each do |name|
        comedian = Comedian.find_or_create_by!(name: name)
        @post.performers.create(comedian: comedian)
      end

      # session削除
      session.delete(:confirm_post_params)
      session.delete(:confirm_performer_names)
      session.delete(:confirm_post_id)
      session.delete(:confirm_poster_signed_id)
      session.delete(:confirm_poster_filename)
      session.delete(:confirm_remove_poster)

      redirect_to posts_path, notice: "投稿を保存しました"
    else
      @places = Place.order(:name)
      @performer_names = params[:performer_names] || []
      render(session[:confirm_post_id] ? :edit : :new, status: :unprocessable_entity)
    end
  end

  def show; end

  def edit
    @post = current_user.posts.find(params[:id])
    @performer_names = @post.performers.includes(:comedian).map { |p| p.comedian.name }
    @places = Place.order(:name)
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_master_data
    @places = Place.order(:name)
  end

  def post_params
    params.require(:post).permit(:live_name, :description, :start_date, :end_date,
                                  :open_date, :price, :live_url, :ticket_start_date,
                                  :ticket_end_date, :place_id)
  end
end
