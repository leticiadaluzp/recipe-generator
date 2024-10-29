# frozen_string_literal: true

require 'rails_helper'

describe 'Recipes' do
  describe 'GET new' do
    subject { get new_recipe_path }

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      it 'have http status 200' do
        expect(subject).to eq(200)
      end
    end

    context 'when not logged in' do
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    subject { post recipes_path, params: }

    # let(:ingredients_string) do
    #   ingredients_array = Array.new(3) { Faker::Food.ingredient }
    #   { ingredients_array: ingredients_array.join(', ') }
    # end

    let(:params) do
      {
        recipe: {
          ingredients: "Eggs, rice, meat"
        }
      }
    end

    context 'when logged in' do
      let!(:user) { create(:user) }

      let!(:response) do
        {
          "id": "chatcmpl-8a2jxRihbDdSvbaVfvIufuMbfoFIk",
          "object": "chat.completion",
          "created": 1703601033,
          "model": "gpt-3.5-turbo-0613",
          "choices": [
              {
                  "index": 0,
                  "message": {
                      "role": "assistant",
                      "content": "{ \"name\": \"French fries\", \"instructions\": \"Cook the dish\" }"
                  },
                  "logprobs": nil,
                  "finish_reason": "stop"
              }
          ],
          "usage": {
              "prompt_tokens": 49,
              "completion_tokens": 74,
              "total_tokens": 123
          },
          "system_fingerprint": nil
      }
      end

      before do
        sign_in user 
        WebMock.stub_request(
          :post,
          'https://api.openai.com/v1/chat/completions'
        ).to_return(status: 200, body: response.to_json)
      end

      context 'when success' do
        it 'creates the recipe' do
          expect { subject }.to change(Recipe, :count).by(1)
        end

        it 'redirect to index with a success notice' do
          subject
          expect(response).to redirect_to(recipes_path)
          expect(flash[:notice]).to eq('Recipe successfully created.')
        end

        it 'have http status 302' do
          expect(subject).to eq(302)
        end
      end

      # context 'when not success' do
      #   let(:params) do
      #     {
      #       recipe: {
      #         name: '',
      #         description: '',
      #         ingredients: ''
      #       }
      #     }
      #   end

      #   it 'does not create the recipe' do
      #     expect { subject }.not_to change(Recipe, :count)
      #   end

      #   it 'has status unprocessable entity' do
      #     subject
      #     expect(response).to have_http_status(:unprocessable_entity)
      #   end

      #   it 'does not display a success notice' do
      #     subject
      #     expect(flash[:notice]).to be_nil
      #   end
      # end
    end

    context 'when not logged in' do
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
