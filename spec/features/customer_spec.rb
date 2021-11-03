require 'rails_helper'
# actually it currently has being used system instead of features
RSpec.feature "Customers", type: :feature do
  it 'visit index page' do
    visit(customers_path)
    expect(page).to have_current_path(customers_path)
  end
  it 'creates a customer' do
    member = create(:member)

    login_as(member, scope: :member)
    visit(new_customer_path)
    fill_in 'Name', with: 'Nome 1'
    fill_in 'Email', with: 'nome1@email.com'
    fill_in 'Address', with: 'Algum endereço'
    click_on 'Create Customer'

    expect(page).to have_content('Customer was successfully created.')
  end
end
