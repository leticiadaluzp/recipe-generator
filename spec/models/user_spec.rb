# frozen_string_literal: true

#
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE), not null
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string           default("")
#  last_name              :string           default("")
#  username               :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

describe User do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }

    context 'when was created with regular login' do
      subject { build(:user) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
      it { is_expected.to validate_presence_of(:email) }
    end
  end

  context 'when was created with regular login' do
    let!(:user) { create(:user) }
    let(:full_name) { user.full_name }

    it 'returns the correct name' do
      expect(full_name).to eq(user.username)
    end
  end

  context 'when user has first_name' do
    let!(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the correct name' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe 'preferences limit' do
    let!(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    context 'when user has reached the maximum preferences limit' do
      before do
        Preference::MAX_PREFERENCES.times do
          create(:preference, user:)
        end
      end

      it 'raises PreferenceLimitExceeded error when adding another preference' do
        expect {
          user.preferences.create!(name: 'Extra Preference', description: 'Description')
        }.to raise_error(PreferenceLimitExceeded,
                         "You can't have more than #{Preference::MAX_PREFERENCES} preferences.")
      end
    end

    context 'when user has not reached the maximum preferences limit' do
      it 'allows creating a new preference' do
        expect {
          user.preferences.create!(name: 'New Preference', description: 'Description')
        }.to change(user.preferences, :count).by(1)
      end
    end
  end

  describe '.from_social_provider' do
    context 'when user does not exist' do
      let(:params) { attributes_for(:user) }

      it 'creates the user' do
        expect {
          described_class.from_social_provider('provider', params)
        }.to change(described_class, :count).by(1)
      end
    end

    context 'when the user exists' do
      let!(:user)  { create(:user, provider: 'provider', uid: 'user@example.com') }
      let(:params) { attributes_for(:user).merge('id' => 'user@example.com') }

      it 'returns the given user' do
        expect(described_class.from_social_provider('provider', params))
          .to eq(user)
      end
    end
  end

  describe '.invite!' do
    let(:inviter) { create(:user) }

    it 'creates a new user with an invitation token' do
      expect {
        described_class.invite!(email: 'invitee@example.com')
      }.to change(described_class, :count).by(1)

      invited_user = described_class.find_by(email: 'invitee@example.com')
      expect(invited_user).not_to be_nil
      expect(invited_user.invitation_token).not_to be_nil
    end

    it 'sends an invitation email' do
      expect {
        described_class.invite!(email: 'invitee@example.com')
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:preferences).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).dependent(:destroy) }
  end
end
