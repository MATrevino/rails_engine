require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    parsed_data = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_data[:data]).to be_an(Array)
    expect(parsed_data[:data].size).to eq(3)
    expect(parsed_data[:data][0].keys).to eq([:id, :type, :attributes])
    expect(parsed_data[:data][0][:attributes][:name]).to eq(Merchant.first.name)
  end

    it "can get one merchant by its id" do
      id = create(:merchant).id 

      get "/api/v1/merchants/#{id}"

      parsed_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(parsed_data[:data]).to be_a(Hash)
      expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])
      expect(parsed_data[:data][:id]).to eq(id.to_s)
      expect(parsed_data[:data][:type]).to eq("merchant")
      expect(parsed_data[:data][:attributes]).to eq({name: Merchant.first.name})
      expect(parsed_data[:data][:attributes].size).to eq(1)
    end

    it "can get all items for a given merchant id" do
      id = create(:merchant).id
      create_list(:item, 3, merchant_id: id)
      # other_item = create_list(:item, 1)

      get "/api/v1/merchants/#{id}/items"

      expect(response).to be_successful

      parsed_items = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_items[:data]).to be_an(Array)
      expect(parsed_items[:data].size).to eq(3)
      expect(parsed_items[:data][0].keys).to eq([:id, :type, :attributes])

      expect(parsed_items[:data][0][:id]).to eq(Item.first.id.to_s)
      expect(parsed_items[:data][0][:type]).to eq("item")
      expect(parsed_items[:data][0][:attributes]).to eq({name: Item.first.name, description: Item.first.description, unit_price: Item.first.unit_price, merchant_id: Item.first.merchant_id})

      expect(parsed_items[:data][0][:attributes].size).to eq(4)
    end

    describe 'non-restful routes: search for all merchants query' do
      it 'can find all merchants that match a search query' do
        merchant1 = create(:merchant, name: "Bob's Burgers")
        merchant2 = create(:merchant, name: "Burger King")
        merchant2 = create(:merchant, name: "Patagonia")

        get "/api/v1/merchants/find_all?name=burger"

        parsed_info = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(parsed_info[:data]).to be_an(Array)
        expect(parsed_info[:data].size).to eq(2)
        expect(parsed_info[:data][0].keys).to eq([:id, :type, :attributes])
      end

      it 'will return an error if no merchant matches the search query' do
        merchant1 = create(:merchant, name: "Bob's Burgers")

        get "/api/v1/merchants/find_all?name=flower"

        parsed_info = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(parsed_info[:errors]).to eq("Couldn't find Merchant")
      end
    end
end