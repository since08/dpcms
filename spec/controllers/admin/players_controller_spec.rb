require 'rails_helper'
RSpec.describe Admin::PlayersController, type: :controller do
  let(:admin_user) { FactoryGirl.create :admin_user }
  let(:player){ FactoryGirl.create(:player) }
  let(:create_params) do
    {
      player: {
          name: 'superman',
          avatar: fixture_file_upload(Rails.root.join('spec/factories/foo.png')),
          country: '美国',
          dpi_total_earning: '222',
          dpi_total_score: '333',
          memo: '备注'
      }
    }
  end

  let(:update_params) do
    {
        player: {
            name: 'test',
            country: 'China',
            dpi_total_score: '100'
        }
    }
  end

  describe ":index" do
    it "should return code: 200" do
      sign_in admin_user
      get :index
      expect(response).to be_success
    end
  end

  describe ":create" do
    it "should create a player data" do
      sign_in admin_user
      post :create, params: create_params, format: :html
      last_insert = Player.last
      expect(last_insert.name).to eq('superman')
      expect(last_insert.country).to eq('美国')
      expect(last_insert.dpi_total_earning).to eq(222)
      expect(last_insert.dpi_total_score).to eq(333)
      expect(last_insert.memo).to eq('备注')
      expect(last_insert.avatar).to be_truthy
    end
  end

  describe ':show' do
    it 'should have an show action' do
      sign_in admin_user
      get :show, params: { id: player.id}
      expect(response).to be_success
    end
  end

  describe ':edit' do
    it 'should have an edit action' do
      sign_in admin_user
      get :edit, params: { id: player.id}
      expect(response).to be_success
    end
  end

  describe ":update" do
    it "should update a player's data" do
      sign_in admin_user
      put :update, params: { id: player.id }.merge(update_params)
      data = Player.last
      expect(data.name).to eq('test')
      expect(data.country).to eq('China')
      expect(data.dpi_total_score).to eq(100)
    end
  end
end