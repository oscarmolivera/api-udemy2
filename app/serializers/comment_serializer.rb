class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content
  has_one :article
  has_one :user
end
