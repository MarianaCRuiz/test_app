require 'rails_helper'
require_relative '../support/new_customer_form'
# actually it currently has being used system instead of features
RSpec.feature "Customers", type: :feature do
  let(:new_customer_form) { NewCustomerForm.new }
  it 'visit index page' do
    visit(customers_path)
    expect(page).to have_current_path(customers_path)
  end
  it 'Find' do
    visit(customers_path)
    expect(find('#my-div').find('h1')).to have_content('Customer')
    expect(page).to have_css('h1', text: 'Customer')
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
  it 'Creates a Customer - Page Object Pattern' do
    new_customer_form.login.visit_page(new_customer_path).fill_in_with(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      address: Faker::Address.street_address
    ).submit

    expect(page).to have_content('Customer was successfully created.')
  end
end
