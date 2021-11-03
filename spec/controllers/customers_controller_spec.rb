require 'rails_helper'
# Test type controller is deprecated, it is here just to see some exemples
RSpec.describe CustomersController, type: :controller do
  it 'responds successfully' do
    get :index
    expect(response).to be_success
  end
end
