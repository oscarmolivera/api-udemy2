class ArticlesController < ApplicationController
  def index
    render json: serializer.new(Article.all)
  end
  
  def show;  end

  private
    def serializer
      ArticleSerializer
    end

end
