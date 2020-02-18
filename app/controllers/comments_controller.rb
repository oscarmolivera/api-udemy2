# frozen_string_literal: true

# Controller for Comment model
class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  before_action :load_article

  def index
    comments = @article.comments

    render json: serializer.new(comments
      .page(params[:page])
      .per(params[:per_page])
    )
  end

  def create
    @comment = @article.comments.build(
      comment_params.merge(user: current_user)
    )
    @comment.save!
    render json: serializer.new(@comment), status: :created, location: @article
  rescue 
    render jsonapi_errors: @comment.errors, status: :unprocessable_entity
  end

  private

  def load_article
    @article = Article.find(params[:article_id])
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:data).require(:attributes).permit(:content) ||
      ActionController::Parameters.new
  end

  def serializer
    CommentSerializer
  end
end
