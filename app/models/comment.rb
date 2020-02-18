# frozen_string_literal: true

# Model of the Comment table
class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :content, presence: true
end
