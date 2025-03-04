class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_comment, only: %i[update destroy]
  before_action :authorize_user!, only: %i[update destroy]

  # GET /articles/:article_id/comments
  def index
    article = Article.find(params[:article_id])
    comments = article.comments
    render json: comments
  end

  # POST /articles/:article_id/comments
  def create
    article = Article.find(params[:article_id])
    comment = article.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_user!
    render json: { error: "Not authorized" }, status: :forbidden unless @comment.user == current_user
  end
end
