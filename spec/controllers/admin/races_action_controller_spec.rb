require 'rails_helper'

RSpec.describe Admin::RacesController, type: :controller do
  let(:admin_user) { FactoryGirl.create :admin_user }
  let(:race) { FactoryGirl.create :race }
  before { sign_in admin_user }

  describe ':publish' do
    it 'should have an publish action' do
      expect(race.published?).to be_falsey
      post :publish, params: { id: race.id }
      expect(response).to redirect_to(admin_races_url)
      expect(race.reload.published?).to be_truthy
    end
  end

  describe ':unpublish' do
    it 'should have an unpublish action' do
      race.publish!
      expect(race.published?).to be_truthy
      post :unpublish, params: { id: race.id }
      expect(response).to redirect_to(admin_races_url)
      expect(race.reload.published?).to be_falsey
    end
  end

  describe ':change_status' do
    it 'should change to go_ahead' do
      expect(race.status).not_to   eq('go_ahead')
      put :change_status, params: { id: race.id, status: 'go_ahead' }
      expect(response).to be_success
      expect(race.reload.status).to   eq('go_ahead')
    end

    it 'should change to ended' do
      expect(race.status).not_to   eq('ended')
      put :change_status, params: { id: race.id, status: 'ended' }
      expect(response).to be_success
      expect(race.reload.status).to   eq('ended')
    end

    it 'should change to closed' do
      expect(race.status).not_to   eq('closed')
      put :change_status, params: { id: race.id, status: 'closed' }
      expect(response).to be_success
      expect(race.reload.status).to   eq('closed')
    end

    it 'should change to unbegin' do
      put :change_status, params: { id: race.id, status: 'closed' }

      expect(race.reload.status).not_to   eq('unbegin')
      put :change_status, params: { id: race.id, status: 'unbegin' }
      expect(response).to be_success
      expect(race.reload.status).to   eq('unbegin')
    end
  end
end
