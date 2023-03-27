require 'rails_helper'

describe 'Invoices API' do
  it 'sends a list of invoices' do
    create_list(:invoice, 3)

    get '/api/v1/invoices'
    
    expect(response).to be_successful

    invoices = JSON.parse(response.body, symbolize_names: true)

    expect(invoices.count).to eq(3)

    invoices.each do |invoice|
      expect(invoice).to have_key(:id)
      expect(invoice[:id]).to be_an(Integer)

      expect(invoice).to have_key(:status)
      expect(invoice[:status]).to be_a(String)

      expect(invoice).to have_key(:customer_id)
      expect(invoice[:customer_id]).to be_an(Integer)

      # expect(invoice).to have_key(:merchant_id)
      # expect(invoice[:merchant_id]).to be_an(Integer)
    end
  end
end