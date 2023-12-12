class PostsController < ApplicationController
  def index
    # @posts = Post.all.order('created_at desc')
    @posts = current_user.friends_and_own_posts
  end

  # def show
  # @post = Post.find(params[:id])
  # end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      # redirect_to @post
      redirect_to root_path
    else
      # to render index from here, @posts needs to be defined again.
      # @posts = Post.all.order('created_at desc')
      # Not sure why the below @posts will show a post with no content on submit, but the version above will not.
      @posts = current_user.friends_and_own_posts
      render :index, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
