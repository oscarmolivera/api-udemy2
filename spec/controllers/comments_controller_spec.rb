require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'GET #index' do
    let(:article) { create :article }
    subject { get :index, params: { article_id: article.id } }
    it 'returns a success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should only return comments from the article' do
      comment = create :comment, article: article
      create :comment
      subject
      expect(json_data.length).to eq(1)
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'should paginate results' do
      comments = create_list :comment, 3, article: article
      get :index, params: { article_id: article.id, page: 2, per_page: 1 }
      expect(json_data.length).to eq(1)
      comment = comments.second
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'should return proper json' do
      user = create :user
      comment = create :comment, article: article, user: user
      subject
      relationships =  json_data.first['relationships']
      expect(relationships['article']['data']['id']).to eq(comment.article_id.to_s)
      expect(relationships['user']['data']['id']).to eq(comment.user_id.to_s)
    end
  end

  describe 'POST #create' do
    let(:article) { create :article }
    subject { post :create, params: { article_id: article.id } }

    context 'when no code provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid code provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'and an invalid content is provided' do
        let(:invalid_attributes) { { data: { attributes: { content: '' } } } }

        subject { post :create, params: invalid_attributes.merge(article_id: article.id) }

        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper error json' do
          subject
          expect(json['errors']).to include(
            {
              "code"=>"blank",
              "detail"=>"Content can't be blank",
              "source"=>{"pointer"=>"/data/attributes/content"},
              "status"=>"422",
              "title"=>"Unprocessable Entity"
            }
            )
        end
      end

      context 'and a valid content is provided' do
        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'content' => 'Test content from Rspec.'
              }
            }
          }
        end

        subject { post :create, params: valid_attributes.merge(article_id: article.id) }

        it 'should respond HTTP Code 201.' do
          subject
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
          expect(response.location).to eq(article_url(article))

        end

        it 'should have proper json body' do
          subject
          expect(json_data['attributes']).to include(
            valid_attributes['data']['attributes']
          )
        end

        it 'should create the comment' do
          expect { subject }.to change { Comment.count }.by(1)
        end
      end
    end
  end
end
