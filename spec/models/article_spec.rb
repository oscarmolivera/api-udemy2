require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#validations" do
    let(:article) { create(:article) }
    
    it "should test that the factory is valid" do
      expect(article).to be_valid
    end
  
    it "should validate the precence of the title" do
      article.title =  ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:title]).to include("can't be blank")
    end
    
  
    it "should validate the precence of the content" do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:content]).to include("can't be blank")
    end
    
    it "should validate the precence of the slug" do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors.messages[:slug]).to include("can't be blank")
    end
  
    it "should validate slug uniqueness" do
      #article2 = create(:article)
      #invalid_article = FactoryBot.build :article, slug: article.slug
      invalid_article = build :article, slug: article.slug
      expect(invalid_article).not_to be_valid      
    end
  end

  describe ".recent" do
    
    it "should return articles in reverse order" do
      old_article = create :article  
      new_article = create :article  
      expect(described_class.recent).to eq([new_article, old_article])
      old_article.update_column :created_at, Time.now()
      expect(described_class.recent).to eq([old_article, new_article])

    end
  end
  
end
