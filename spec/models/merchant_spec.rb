require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    it '.search_by_name' do
      merchant1 = create(:merchant, name: "Burger King")
      merchant2 = create(:merchant, name: "Bob's Burgers")
      merchant3 = create(:merchant, name: "Patagonia")

      expect(Merchant.search_by_name("burger")).to eq([merchant2, merchant1])
    end
  end
end