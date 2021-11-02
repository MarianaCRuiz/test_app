require 'rails_helper'

RSpec.describe Customer, type: :model do
  # fixtures :all
  it '#full_name' do
    # customer = customers(:fulano) -> para fixtures
    customer = create(:customer)
    expect(customer.full_name).to start_with('Sr.')
  end
  it '#full_name - overwriting attributes' do
    customer = create(:customer, name: 'Nome 1', vip: false, days_to_pay: 10)
    expect(customer.full_name).to start_with('Sr. Nome 1')
    expect(customer.vip).to be false
    expect(customer.days_to_pay).to eq(10)
  end
  it '#full_name - heritage vip' do
    customer = create(:customer_vip, name: 'Nome 1')
    expect(customer.full_name).to start_with('Sr. Nome 1')
    expect(customer.vip).to be true
    expect(customer.days_to_pay).to eq(30)
  end
  it '#full_name - heritage default' do
    customer = create(:customer_default, name: 'Nome 1')
    expect(customer.full_name).to start_with('Sr. Nome 1')
    expect(customer.vip).to be false
    expect(customer.days_to_pay).to eq(10)
  end
  it '#full_name - aliases' do
    customer = create(:client, name: 'Nome 1')
    expect(customer.full_name).to start_with('Sr. Nome 1')
  end
  it 'using attributes_for' do
    attrs = attributes_for(:customer, name: 'Nome 1')
    attrs_vip = attributes_for(:customer_vip)
    attrs_default = attributes_for(:customer_default)
    expect(attrs[:name]).to eq('Nome 1')
    expect(attrs_vip[:vip]).to eq(true)
    expect(attrs_default[:vip]).to eq(false)
  end
  it '#full_name - attributes_for' do
    attrs = attributes_for(:customer_default, name: 'Nome 1')
    customer = Customer.create(attrs)
    expect(customer.full_name).to start_with('Sr. Nome 1')
    expect(customer.vip).to be false
    expect(customer.days_to_pay).to eq(10)
  end
  it 'transient attributes' do
    customer = create(:customer_default, upcased: true)
    expect(customer.name.upcase).to eq(customer.name)
  end
  it 'traits' do
    customer_male = create(:customer_vip, :male)
    customer_female = create(:customer_vip, :female)
    expect(customer_male.gender).to eq('M')
    expect(customer_male.vip).to be true
    expect(customer_female.gender).to eq('F')
    expect(customer_female.vip).to be true
  end
  it 'trait and heritage' do
    customer_male = create(:customer_male_vip)
    customer_female = create(:customer_female_default)
    expect(customer_male.gender).to eq('M')
    expect(customer_male.vip).to be true
    expect(customer_female.gender).to eq('F')
    expect(customer_female.vip).to be false
  end
  it 'travel_to' do
    travel_to Time.zone.local(2011, 10, 01, 01, 04, 00, 0000) do
      @customer = create(:customer_default)
    end
    expect(@customer.created_at).to eq(Time.new(2011, 10, 01, 01, 04, 00, 0000))
    expect(@customer.created_at).to be < Time.now
  end
  it { expect{ create(:customer) }.to change{ Customer.all.size }.by(1) }
end
