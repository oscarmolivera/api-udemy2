FactoryBot.define do
  # "Article N°1 Title"
  # "AWESOME Content from article1..." 
  # "article-1-url-slug" 
  factory :article do
    sequence(:title) { |t| "Article N°#{t} Title" }
    sequence(:content) { |c| "AWESOME Content from article#{c}..." }
    sequence(:slug) { |s| "article-#{s}-url-slug" }
  end
end


