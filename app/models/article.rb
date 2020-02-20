# frozen_string_literal: true

# Article Model
class Article < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :recent, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy
end
