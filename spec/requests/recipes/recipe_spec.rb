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
          name: '',
          description: '',
          ingredients: ''
        }
      }
    end

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      context 'when success' do
        it 'creates the recipe' do
          expect { subject }.to change(Recipe, :count).by(1)
        end

        it 'redirect to index' do
          expect(subject).to redirect_to(recipes_path)
        end

        it 'have http status 302' do
          expect(subject).to eq(302)
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
end
