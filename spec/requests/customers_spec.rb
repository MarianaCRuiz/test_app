require 'rails_helper'

RSpec.describe "Customers", type: :request do
  describe "GET /customers" do
    it "works! (now write some real specs)" do
      get customers_path
      expect(response).to have_http_status(200)
    end
    it 'index JSON' do
      customer = Customer.first
      customer ||= create(:customer)
      get '/customers.json'
      expect(response).to have_http_status(200)
      expect(response.body).to include_json([
        id: /\d/,
        name: be_kind_of(String),
        email: customer.email
      ])
    end
    it 'show JSON' do
      member = create(:member)
      customer = create(:customer)
      login_as(member, scope: :member)
      get "/customers/#{customer.id}.json"
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        id: customer.id,
        name: customer.name,
        email: customer.email
      )
    end
    it 'create JSON' do
      customer_params = attributes_for(:customer)
      member = create(:member)
      login_as(member, scope: :member)
      headers = {'ACCEPT' => 'aplication/json'}
      post "/customers.json", params: { customer: customer_params }, headers: headers
      expect(response).to have_http_status(201)
      expect(response.body).to include_json(
        id: /\d/,
        name: customer_params[:name],
        email: customer_params[:email]
      )
    end
    it 'update JSON' do
      create(:customer)
      customer = Customer.last
      member = create(:member)
      login_as(member, scope: :member)
      headers = {'ACCEPT' => 'aplication/json'}
      patch "/customers/#{customer.id}.json", params: { customer: { name: 'Nome Novo'} }, headers: headers
      expect(response).to have_http_status(200)
      expect(response.body).to include_json(
        id: /\d/,
        name: 'Nome Novo',
        email: customer.email
      )
    end
    it 'destroy JSON' do
      create(:customer)
      customer = Customer.last
      member = create(:member)
      login_as(member, scope: :member)
      headers = {'ACCEPT' => 'aplication/json'}
      url = "/customers/#{customer.id}.json"
      expect { delete url, headers: headers }.to change{ Customer.count }.by(-1)
      expect(response).to have_http_status(204)
    end
  end
end
