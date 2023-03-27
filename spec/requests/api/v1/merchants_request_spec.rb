require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

    it "can get one merchant by its id" do
      id = create(:merchant).id 

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end

    it "can get all items for a given merchant id" do
      id = create(:merchant).id
      create_list(:item, 3, merchant_id: id)
      other_item = create_list(:item, 1)

      get "/api/v1/merchants/#{id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items.count).to eq(3)
      expect(merchant_items).not_to include(other_item)

      merchant_items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)

        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)

        expect(item).to have_key(:description)
        expect(item[:description]).to be_a(String)
      end
    end
end