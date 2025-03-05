class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: %i[show update destroy]
  before_action :authorize_user!, only: %i[update destroy]

  # GET /articles
  def index
    if user_signed_in?
      articles = Article.where("private = ? OR user_id = ?", false, current_user.id)
    else
      articles = Article.all
    end
    render json: articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    article = current_user.articles.new(article_params)
    if article.save
      render json: article, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.expect(article: [ :title, :content ])
    end

    def authorize_user!
      render json: { error: "Not authorized" }, status: :forbidden unless @article.user == current_user
    end
end
