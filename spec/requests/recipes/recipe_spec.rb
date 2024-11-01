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
          ingredients: 'Eggs, rice, meat'
        }
      }
    end

    context 'when logged in' do
      let!(:user) { create(:user) }

      let!(:response_body) do
        {
          id: 'chatcmpl-8a2jxRihbDdSvbaVfvIufuMbfoFIk',
          object: 'chat.completion',
          created: 1_703_601_033,
          model: 'gpt-3.5-turbo-0613',
          choices: [
            {
              index: 0,
              message: {
                role: 'assistant',
                content: '{ "name": "French fries", "instructions": "Cook the dish" }'
              },
              logprobs: nil,
              finish_reason: 'stop'
            }
          ],
          usage: {
            prompt_tokens: 49,
            completion_tokens: 74,
            total_tokens: 123
          },
          system_fingerprint: nil
        }
      end

      before do
        sign_in user
        WebMock.stub_request(
          :post,
          'https://api.openai.com/v1/chat/completions'
        ).to_return(status: 200, body: response_body.to_json)
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

      context 'when not success' do
        # context 'when the recipe creation fails' do
        #   let(:response_body) do
        #     {
        #       "id": "chatcmpl-8a2jxRihbDdSvbaVfvIufuMbfoFIk",
        #       "object": "chat.completion",
        #       "created": 1703601033,
        #       "model": "gpt-3.5-turbo-0613",
        #       "choices": [
        #           {
        #               "index": 0,
        #               "message": {
        #                   "role": "assistant",
        #                   "content": "{ \"name\": \"\", \"instructions\": \"\" }"
        #                 },
        #               "logprobs": nil,
        #               "finish_reason": "stop"
        #           }
        #       ],
        #       "usage": {
        #           "prompt_tokens": 49,
        #           "completion_tokens": 74,
        #           "total_tokens": 123
        #       },
        #       "system_fingerprint": nil
        #     }
        #   end

        #   before do
        #     sign_in user
        #     WebMock.stub_request(
        #       :post,
        #       'https://api.openai.com/v1/chat/completions'
        #     ).to_return(status: 200, body: response_body.to_json)
        #   end

        #   it 'does not create the recipe' do
        #     expect { subject }.not_to change(Recipe, :count)
        #   end

        #   it 'renders the new template with status unprocessable entity' do
        #     subject
        #     expect(response).to have_http_status(:unprocessable_entity)
        #     expect(response).to render_template(:new)
        #   end
        # end

        context 'when the json fails' do
          let(:response_body) do
            {
              id: 'chatcmpl-8a2jxRihbDdSvbaVfvIufuMbfoFIk',
              object: 'chat.completion',
              created: 1_703_601_033,
              model: 'gpt-3.5-turbo-0613',
              choices: [
                {
                  index: 0,
                  message: {
                    role: 'assistant',
                    content: ''
                  },
                  logprobs: nil,
                  finish_reason: 'stop'
                }
              ],
              usage: {
                prompt_tokens: 49,
                completion_tokens: 74,
                total_tokens: 123
              },
              system_fingerprint: nil
            }
          end

          before do
            sign_in user
            WebMock.stub_request(
              :post,
              'https://api.openai.com/v1/chat/completions'
            ).to_return(status: 200, body: response_body.to_json)
          end

          it 'does not create the recipe' do
            expect { subject }.not_to change(Recipe, :count)
          end

          it 'redirects to recipes_path with an alert' do
            subject
            expect(response).to redirect_to(recipes_path)
            expect(flash[:alert]).to be_present
          end
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE destroy' do
    subject { delete recipe_path(recipe) }

    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user_id: user.id) }

    context 'when logged in' do
      before do
        sign_in user
      end

      it 'destroys the recipe' do
        expect {
          subject
        }.to change(Recipe, :count).by(-1)
      end

      it 'redirects to the recipes path with a success notice' do
        subject
        expect(response).to redirect_to(recipes_path)
        expect(flash[:notice]).to eq('Recipe successfully removed.')
      end
    end

    context 'when destroy fails' do
      before do
        allow_any_instance_of(Recipe).to receive(:destroy).and_return(false)
        sign_in user
      end

      it 'does not change the recipe count' do
        expect {
          subject
        }.not_to change(Recipe, :count)
      end

      it 'has status unprocessable entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when not logged in' do
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'does not change the recipes count' do
        expect {
          subject
        }.not_to change(Recipe, :count)
      end
    end
  end
end
