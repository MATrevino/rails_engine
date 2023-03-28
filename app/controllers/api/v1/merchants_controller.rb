class Api::V1::MerchantsController < ApplicationController
  def index
    # merchants = Merchant.all
    # render json: MerchantSerializer.format_merchant(merchants)
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
  #   merchant = Merchant.find(params[:id])
  #   render json: MerchantSerializer.format_merchant_show(merchant)

    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end