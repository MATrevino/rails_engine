require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe 'class methods' do
    it '.search_by_name' do
      merchant_id = create(:merchant).id
      item1 = create(:item, name: "Dog toy", merchant_id: merchant_id)
      item2 = create(:item, name: "Dog bed", merchant_id: merchant_id)
      item3 = create(:item, name: "Cat toy", merchant_id: merchant_id)

      expect(Item.search_by_name("dog")).to eq(item2)
      expect(Item.search_by_name("Dog")).to eq(item2)
      expect(Item.search_by_name("Do")).to eq(item2)
    end

    it '.min_price' do
      merchant_id = create(:merchant).id
      item1 = create(:item, name: "Dog toy", unit_price: 2.00, merchant_id: merchant_id)
      item2 = create(:item, name: "Dog sweater", unit_price: 15.00, merchant_id: merchant_id)
      item3 = create(:item, name: "Dog bed", unit_price: 12.00, merchant_id: merchant_id)

      expect(Item.min_price(10.00)).to eq([item3, item2])
    end

    it '.max_price' do
      merchant_id = create(:merchant).id
      item1 = create(:item, name: "Dog toy", unit_price: 2.00, merchant_id: merchant_id)
      item2 = create(:item, name: "Dog sweater", unit_price: 15.00, merchant_id: merchant_id)
      item3 = create(:item, name: "Dog bed", unit_price: 12.00, merchant_id: merchant_id)

      expect(Item.max_price(10.00)).to eq([item1])
    end
  end
end