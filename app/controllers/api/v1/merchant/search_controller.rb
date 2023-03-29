class Api::V1::Merchant::SearchController < ApplicationController
  def index
    @merchant = Merchant.search_by_name(params[:name])
    if @merchant.empty?
      render json: { errors: "Couldn't find Merchant" }
    else
      render json: MerchantSerializer.new(@merchant)
    end
  end
end