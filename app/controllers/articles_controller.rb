class ArticlesController < ApplicationController
  
  skip_before_action :authorize!, only: [:index, :show]

  def index
    render json: serializer.new(Article.recent.page(params[:page]).per(params[:per_page]))
  end
  
  def show
    render json: serializer.new(Article.find_by(id: params[:id]))
  end

  def create
    article = Article.new(article_params)
    if article.valid?
    else
      render jsonapi_errors: article.errors, status: :unprocessable_entity
    end
  end

  private
    def serializer
      ArticleSerializer
    end

    def article_params
      ActionController::Parameters.new
    end

end
