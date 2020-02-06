require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe "#index" do
    subject {get :index}
    it "should retrun success responds" do
      subject
      expect(response).to  have_http_status(:ok)
    end

    it "should return a proper JSON object" do 
      #pp json # => impime la variable
      create_list :article, 2
      subject
      Article.recent.each.with_index do |article, index|
        expect(json_data[index]['attributes']).to  eq(
          {
            "title" => article.title,
            "content" => article.content,
            "slug" => article.slug          
          }
        )
      end
    end

    it "should return articles in reverse order" do
      first_article = create :article
      second_article = create :article
      subject
      expect(json_data.first['id']).to  eq(second_article.id.to_s)
      expect(json_data.last['id']).to  eq(first_article.id.to_s)
    end

    it "should paginate the response of articles" do
      articles = create_list :article, 3
      get :index, params: {page: 2, per_page: 1}
      expect(json_data.length).to eq(1)
      expected_id = Article.recent.second.id.to_s
      expect(json_data.first['id']).to eq(expected_id)

    end
  end

  describe "#show" do
    
    it "should return success responds" do
      get :show, params: {id: 1}
      expect(response).to  have_http_status(:ok)
    end

    it "should return a proper JSON object" do 
      #pp json # => impime la variable
      article = create :article
      get :show, params:{id: article.id}
      pp json_data
      pp article
      expect(json_data['attributes']).to eq({
        "title" => article.title,
        "content" => article.content,
        "slug" => article.slug  
      })
    end
    
  end
  
end
