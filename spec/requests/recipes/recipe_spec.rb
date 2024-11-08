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
        context 'when the recipe creation fails' do
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
                    content: '{ "name": "", "instructions": "" }'
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

          it 'has unprocessable entity status' do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

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

  describe 'GET show' do
    subject { get(recipe_path(recipe.id)) }

    let!(:user) { create(:user) }
    let!(:recipe) do
      create(:recipe, user_id: user.id, name: 'Pasta', description: 'Cook the dish',
                      ingredients: 'Pasta, Tomato sauce, Cheese')
    end

    context 'when logged in' do
      before { sign_in user }

      it 'have http status 200' do
        expect(subject).to eq(200)
      end

      it 'has the correct recipe attributes' do
        subject
        expect(recipe.user_id).to eq(user.id)
        expect(recipe.name).to eq('Pasta')
        expect(recipe.description).to eq('Cook the dish')
        expect(recipe.ingredients).to eq('Pasta, Tomato sauce, Cheese')
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

    context 'when trying to destroy a recipe that does not belong to the logged-in user' do
      subject { delete recipe_path(other_recipe) }

      let!(:other_user) { create(:user) }
      let!(:other_recipe) { create(:recipe, user: other_user) }

      before do
        sign_in user
      end

      it 'does not change the recipe count' do
        expect {
          subject
        }.not_to change(Recipe, :count)
      end

      it 'redirects to the recipes path with a failure alert' do
        subject
        expect(response).to redirect_to(recipes_path)
        expect(flash[:alert]).to eq('Failed to remove the recipe.')
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
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end
end
