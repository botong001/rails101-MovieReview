class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      current_user.join!(@group)

      redirect_to group_path(@group)
    else
      render :new, flash[:warning] = "请先登录！"
    end
  end

    def edit
      @group = Group.find(params[:group_id])
      @post = Post.find(params[:id])
      @post.group = @group
    end

    def update
      @group = Group.find(params[:group_id])
      @post = Post.find(params[:id])
      @post.group = @group
      @post.user = current_user

      if @post.update(post_params)
        redirect_to account_posts_path, notice: "影评更新成功"
      else
        render :edit
      end
    end

    def destroy
      @group = Group.find(params[:group_id])
      @post = Post.find(params[:id])
      @post.group = @group
      @post.destroy
      flash[:alert] = "影评已删除"
      redirect_to account_posts_path
    end

private
def post_params
  params.require(:post).permit(:content)
end
end
