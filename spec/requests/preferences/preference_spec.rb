# frozen_string_literal: true

require 'rails_helper'

describe 'Preferences' do
  describe 'GET new' do
    subject { get new_preference_path }

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      it 'have http status 200' do
        expect(subject).to eq(200)
      end
    end
  end

  describe 'GET show' do
    context 'when logged in' do
      let!(:user) { create(:user) }
      let!(:preference) { create(:preference, user_id: user.id) }
      let!(:id) do
        preference.id
      end

      before { sign_in user }

      it 'have http status 200' do
        expect(get(preference_path(preference.id))).to eq(200)
      end
    end
  end

  describe 'POST create' do
    subject { post preferences_path, params: }

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      context 'when success' do
        let(:params) do
          {
            preference: {
              name: 'RandomName',
              description: 'RandomDescription',
              restriction: false
            }
          }
        end

        it 'creates the preference' do
          expect { subject }.to change(Preference, :count).by(1)
        end

        it 'redirect to index' do
          expect(subject).to redirect_to(preferences_path)
        end

        it 'have http status 302' do
          expect(subject).to eq(302)
        end
      end

      context 'when fails' do
        let(:params) do
          {
            preference: {
              description: 'RandomDescription',
              restriction: false
            }
          }
        end

        it 'have http status 422' do
          expect(subject).to eq(422)
        end
      end
    end
  end

  describe 'GET edit' do
    subject { get(edit_preference_path(preference.id)) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user_id: user.id) }

    context 'when logged in' do
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

  describe 'PUT update' do
    subject { put preference_path(preference.id), params: }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user_id: user.id) }
    let(:params) do
      {
        preference: {
          name: 'DifferentName',
          description: 'DifferentDescription',
          restriction: false
        }
      }
    end

    context 'when logged in' do
      before { sign_in user }

      context 'when success' do
        it 'have http status 302' do
          expect(subject).to eq(302)
        end

        it 'redirect to index' do
          expect(subject).to redirect_to(preferences_path)
        end

        it 'updates attributes correctly' do
          subject
          preference.reload
          expect(preference.name).to eq('DifferentName')
          expect(preference.description).to eq('DifferentDescription')
          expect(preference.restriction).to be(false)
        end
      end

      context 'when fails' do
        let(:params) do
          {
            preference: {
              name: nil,
              description: 'DifferentDescription',
              restriction: false
            }
          }
        end

        it 'has status unprocessable entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
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
    subject { delete preference_path(preference) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user_id: user.id) }

    context 'when logged in' do
      before do
        sign_in user
      end

      it 'destroys the preference' do
        expect {
          subject
        }.to change(Preference, :count).by(-1)
      end

      it 'redirects to the preferences path with a success notice' do
        subject
        expect(response).to redirect_to(preferences_path)
        expect(flash[:notice]).to eq('Preference successfully removed.')
      end
    end

    context 'when destroy fails' do
      before do
        allow_any_instance_of(Preference).to receive(:destroy).and_return(false)
        sign_in user
      end

      it 'does not change the preference count' do
        expect {
          subject
        }.not_to change(Preference, :count)
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

      it 'does not change the preference count' do
        expect {
          subject
        }.not_to change(Preference, :count)
      end
    end
  end
end
