FactoryBot.define do
  factory :article do
    sequence(:title) { |t| "Article N°#{t} Title" }
    sequence(:content) { |c| "AWESOME Content from article#{c}..." }
    sequence(:slug) { |s| "article-#{s}-url-slug" }
    association :user
  end
end
