class ArticlesController < ApplicationController
  
  skip_before_action :authorize!, only: [:index, :show]

  def index
    render json: serializer.new(Article.recent.page(params[:page]).per(params[:per_page]))
  end
  
  def show
    render json: serializer.new(Article.find_by(id: params[:id]))
  end

  def create
    article = current_user.articles.build(article_params)
    article.save!
    render json: serializer.new(article), status: :created
    rescue
      render jsonapi_errors: article.errors, status: :unprocessable_entity 
  end

  def update
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: serializer.new(article), status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
    render jsonapi_errors: article.errors, status: :unprocessable_entity 
  end

  private
    def serializer
      ArticleSerializer
    end

    def article_params
        params.require(:data).require(:attributes).permit(:title, :content, :slug) ||
        ActionController::Parameters.new
    end

end
