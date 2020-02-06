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
      articles = create_list :article, 2
      subject
      articles.each.with_index do |article, index|
        expect(json_data[index]['attributes']).to  eq(
          {
            "title" => article.title,
            "content" => article.content,
            "slug" => article.slug          
          }
        )
      end
    end
  end
end
