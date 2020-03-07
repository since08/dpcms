require 'rails_helper'

RSpec.describe Admin::RacesController, type: :controller do
  let(:admin_user) { FactoryGirl.create :admin_user }
  let(:race) { FactoryGirl.create :race }
  let(:race_params) do
    {
      race:{
        name:'2017皇城五坛系列赛-第五场',
        prize:'100000',
        location:'北京',
        status:'unbegin',
        logo: fixture_file_upload(Rails.root.join('spec/factories/foo.png')),
        race_en_attributes:{
          logo:''
        },
        race_desc_en_attributes:{
          description:'test description test description'
        },
        race_desc_attributes:{
          description:'test description test description'
        }
      }
    }
  end
  describe ':index' do
    it 'should have an index action' do
      sign_in admin_user
      get :index
      expect(response).to be_success
    end
  end

  describe ':new' do
    describe 'unauthenticated' do
      it 'should redirect_to login' do
        get :new
        expect(response).to redirect_to(new_admin_user_session_url)
      end
    end
    describe 'authenticated' do
      it 'should success' do
        sign_in admin_user
        get :new
        expect(response).to be_success
      end
    end
  end

  describe ':create' do
    it 'should have an create action' do
      sign_in admin_user
      post :create, params: race_params
      
      race = Race.last
      expect(response).to redirect_to(admin_race_url(race.id))
      expect(race.race_desc).to be_truthy
    end
  end

  describe ':show' do
    it 'should have an show action' do
      sign_in admin_user
      get :show, params: { id: race.id}
      expect(response).to be_success
    end
  end

  describe ':edit' do
    it 'should have an edit action' do
      sign_in admin_user
      get :edit, params: { id: race.id}
      expect(response).to be_success
    end
  end

  describe ':update' do
    it 'should have an update action' do
      sign_in admin_user
      put :update, params: { id: race.id}.merge(race_params)

      race.reload
      expect(response).to         redirect_to(admin_race_url(race.id))
      expect(race.race_desc).to   be_truthy
    end
  end

  describe ':delete' do
    it 'success should be deleted' do
      sign_in admin_user
      delete :destroy, params: { id: race.id }

      expect(response).to redirect_to(admin_races_url)
      expect(Race.find_by(id: race.id)).to be_falsey
    end

    it 'delete failed' do
      sign_in admin_user
      race.publish!
      delete :destroy, params: { id: race.id }

      expect(response).to redirect_to(admin_races_url)
      expect(flash[:error]).to eq('已发布的赛事，不允许删除')
      expect(Race.find_by(id: race.id)).to be_truthy
    end
  end
end
