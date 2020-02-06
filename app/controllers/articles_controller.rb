class ArticlesController < ApplicationController
  def index
    render json: serializer.new(Article.recent)
  end
  
  def show;  end

  private
    def serializer
      ArticleSerializer
    end

end
