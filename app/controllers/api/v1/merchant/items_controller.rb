class Api::V1::Merchant::ItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
    render json: ItemSerializer.new(items)
  end
end