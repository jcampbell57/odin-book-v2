class PostsController < ApplicationController
  def index
    @posts = current_user.friends_and_own_posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      ActionCable.server.broadcast('post',
                                   ApplicationController.renderer.render(partial: 'posts/post',
                                                                         locals: { post: @post,
                                                                                   current_user: }))
      flash[:success] = 'Post created'
    else
      flash[:danger] = "Unable to post: #{@post.errors.full_messages.join(', ')}"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @post = Post.find(params[:id])
    return unless current_user.id == @post.user_id

    if @post.destroy
      flash[:success] = 'Post deleted'
    else
      flash[:danger] = "Unable to delete post: #{@post.errors.full_messages.join(', ')}"
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
