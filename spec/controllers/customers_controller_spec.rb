require 'rails_helper'
# Test type controller is deprecated, it is here just to see some exemples
RSpec.describe CustomersController, type: :controller do
  context 'routes' do
    it { should route(:get, '/customers').to(action: :index)}
  end
  context 'not signed in' do
    it 'index responds a 200 - success' do
      get :index
      expect(response).to be_success
    end
    it 'show responds a 302 - not authorized' do
      customer = create(:customer)
      get :show, params: { id: customer.id }
      expect(response).to have_http_status(302)
    end
  end
  context 'signed in as member' do
    before do
      @member = create(:member)
      @customer = create(:customer)
    end
    it 'create with valid attributes' do
      customer_params = attributes_for(:customer)
      sign_in @member
      expect { post :create, params: { customer: customer_params } }.to change { Customer.count }.by(1)
    end
    it 'fail to create - invalid attributes' do
      customer_params = attributes_for(:customer, address: nil)
      sign_in @member
      expect { post :create, params: { customer: customer_params } }.not_to change { Customer.count }
    end
    it 'flash notice successfully create' do
      customer_params = attributes_for(:customer)
      sign_in @member
      post :create, params: { customer: customer_params }
      expect(flash[:notice]).to match(/successfully created/)
    end
    it 'content_type to format json' do
      customer_params = attributes_for(:customer)
      sign_in @member
      post :create, format: :json, params: { customer: customer_params }
      expect(response.content_type).to eq('application/json')
    end
    it 'show responds a 200 - success' do
      sign_in @member
      get :show, params: { id: @customer.id }
      expect(response).to have_http_status(200)
    end
  end
end
