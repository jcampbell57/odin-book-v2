class PostsController < ApplicationController
  def index
    @pagy, @posts = pagy_countless(Post.friends_and_own_posts(current_user), items: 5)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
      broadcast_post_creation
      flash.now[:success] = 'Post created'
    else
      flash.now[:danger] = "Unable to post: #{@post.errors.full_messages.join(', ')}"
    end
    render turbo_stream: turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: })
  end

  def destroy
    @post = Post.find(params[:id])
    return unless current_user.id == @post.user_id

    if @post.destroy
      flash.now[:success] = 'Post deleted'
      render turbo_stream: [
        turbo_stream.remove(@post),
        turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: })
      ]
    else
      flash.now[:danger] = "Unable to delete post: #{@post.errors.full_messages.join(', ')}"
      render turbo_stream: turbo_stream.replace('flash_alert', partial: 'layouts/flash', locals: { flash: })
    end
  end

  private

  def broadcast_post_creation
    ActionCable.server.broadcast('post',
                                 ApplicationController.renderer.render(partial: 'posts/post',
                                                                       locals: {
                                                                         post: @post, current_user:
                                                                       }))
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
