require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  let(:admin_user) { FactoryGirl.create :admin_user }

  describe ':create' do
    it 'should have an create action' do
      params = { image: fixture_file_upload(Rails.root.join('spec/factories/foo.png')) }
      sign_in admin_user
      post :create, params: params
      
      json = JSON.parse(response.body)
      expect(json['success']).to eq(true)
    end
  end
end
