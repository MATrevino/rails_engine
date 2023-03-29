require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    parsed_items = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_items[:data]).to be_an(Array)
    expect(parsed_items[:data].size).to eq(3)
    expect(parsed_items[:data][0].keys).to eq([:id, :type, :attributes])
    expect(parsed_items[:data][0][:attributes][:name]).to eq(Item.first.name)
  end

    it 'can get one item by its id' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(parsed_item[:data]).to be_a(Hash)
      expect(parsed_item[:data].keys).to eq([:id, :type, :attributes])
      expect(parsed_item[:data][:id]).to eq(id.to_s)
      expect(parsed_item[:data][:type]).to eq("item")
      expect(parsed_item[:data][:attributes]).to eq({name: Item.first.name, description: Item.first.description, unit_price: Item.first.unit_price, merchant_id: Item.first.merchant_id})
      expect(parsed_item[:data][:attributes].size).to eq(4)
    end

    it 'can create a new item' do
      id = create(:merchant).id

      item_params = ({
                    name: "Rubber Duck",
                    description: "A rubber duck",
                    unit_price: 1.50,
                    merchant_id: id
                   })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last
      
      expect(response).to be_successful
      expect(created_item[:name]).to eq(item_params[:name])
      expect(created_item[:description]).to eq(item_params[:description])
      expect(created_item[:unit_price]).to eq(item_params[:unit_price])
      expect(created_item[:merchant_id]).to eq(item_params[:merchant_id])
    end

    it 'cannot create a new item with missing params' do
      id = create(:merchant).id

      item_params = ({
                    name: "Rubber Duck",
                    description: "A rubber duck",
                    unit_price: "",
                    merchant_id: id
                   })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'can update an existing item' do
      id = create(:item).id 
      previous_item = Item.last.name
      item_params = { name: "Rubber Duck" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item[:name]).to_not eq(previous_item)
      expect(item[:name]).to eq("Rubber Duck")
      expect(item[:description]).to eq(Item.last.description)
      expect(item[:unit_price]).to eq(Item.last.unit_price)
    end

    it 'cannot update an item with missing params' do
      id = create(:item).id 
      previous_item = Item.last.name
      item_params = { name: "" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
    end

    it 'can destroy an item' do
      item = create(:item)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can get the merchant data associated for a given item ID' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      parsed_info = JSON.parse(response.body, symbolize_names: true)
      
      expect(parsed_info[:data]).to be_a(Hash)
      expect(parsed_info[:data].size).to eq(3)
      expect(parsed_info[:data].keys).to eq([:id, :type, :attributes])
      expect(parsed_info[:data][:id]).to eq(merchant.id.to_s)
      expect(parsed_info[:data][:type]).to eq("merchant")
      expect(parsed_info[:data][:attributes]).to eq({name: Merchant.first.name})
    end

    describe 'non-restful routes' do
      it 'can find an item by name' do
        merchant_id = create(:merchant).id
        item1 = create(:item, name: "Dog toy", merchant_id: merchant_id)
        item2 = create(:item, name: "Dog bed", merchant_id: merchant_id)
        item3 = create(:item, name: "Cat toy", merchant_id: merchant_id)

        get "/api/v1/items/find?name=dog"

        parsed_info = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful
        expect(parsed_info[:data]).to be_a(Hash)
        expect(parsed_info.size).to eq(1)
        expect(parsed_info[:data].keys).to eq([:id, :type, :attributes])
      end

      it 'will return an error if no item is found' do
        merchant_id = create(:merchant).id
        item1 = create(:item, name: "Dog toy", merchant_id: merchant_id)
        item2 = create(:item, name: "Dog bed", merchant_id: merchant_id)
        item3 = create(:item, name: "Cat toy", merchant_id: merchant_id)

        get "/api/v1/items/find?name=capybara"

        parsed_info = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(parsed_info[:errors]).to eq("Couldn't find Item")
      end
    end
end