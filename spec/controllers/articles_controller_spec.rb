require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe '#index' do
    subject { get :index }

    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      create_list :article, 2
      subject
      Article.recent.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq({
          "title" => article.title,
          "content" => article.content,
          "slug" => article.slug
        })
      end
    end

    it 'should return articles in the proper order' do
      old_article = create :article
      newer_article = create :article
      subject
      expect(json_data.first['id']).to eq(newer_article.id.to_s)
      expect(json_data.last['id']).to eq(old_article.id.to_s)
    end

    it 'should paginate results' do
      create_list :article, 3
      get :index, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq 1
      expected_article = Article.recent.second.id.to_s
      expect(json_data.first['id']).to eq(expected_article)
    end
  end

  describe '#show' do
    it "should return success responds" do
      get :show, params: {id: 1}
      expect(response).to  have_http_status(:ok)
    end

    it "should return a proper JSON object" do 
      #pp json # => impime la variable
      article = create :article
      get :show, params:{id: article.id}
      json_data
      article
      expect(json_data['attributes']).to eq({
        "title" => article.title,
        "content" => article.content,
        "slug" => article.slug  
      })
    end

  end

  describe '#create' do
    subject {post :create}
    context 'when no code is provided' do
      it_behaves_like "forbidden_requests"
    end#context

    context 'when provided code is invalid' do
      before {request.headers['authorization'] = "invalid_token"}
      it_behaves_like "forbidden_requests"
    end#context

    context 'when authorized and' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before {request.headers['authorization'] = "Bearer #{access_token.token}"}
      context 'when invalid parameters are provided' do
        let(:invalid_attributes) do 
          {
            data: {
              attributes: {
                title: '',
                content: ''
              }
            }
          }
        end
        subject {post :create, params: invalid_attributes}
        it "should responds a 422 UE code" do
          subject
          expect(response).to have_http_status(422)
        end
  
        it " should responds a proper Json error object" do
          subject
          expect(json['errors']).to include(
            {
              "code"=>"blank",
              "detail"=>"Title can't be blank",
              "source"=>{"pointer"=>"/data/attributes/title"},
              "status"=>"422",
              "title"=>"Unprocessable Entity"},
            {
              "code"=>"blank",
              "detail"=>"Content can't be blank",
              "source"=>{"pointer"=>"/data/attributes/content"},
              "status"=>"422",
              "title"=>"Unprocessable Entity"},
            {
              "code"=>"blank",
              "detail"=>"Slug can't be blank",
              "source"=>{"pointer"=>"/data/attributes/slug"},
              "status"=>"422",
              "title"=>"Unprocessable Entity"
            }
          )
        end
      end#context_b
    end#context_a

  end#describe_CREATE
end
