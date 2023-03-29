class Api::V1::Item::SearchController < ApplicationController

  def show
    if (params[:name] && (params[:min_price] || params[:max_price]))
      render json: { errors: "Can't search for name and price" }
    elsif params[:name]
      name_search
    else params[:min_price] || params[:max_price]
      price_search
    end
  end

  def name_search
    if Item.search_by_name(params[:name]).nil?
      render json: { errors: "Couldn't find Item" }
    else
      render json: ItemSerializer.new(Item.search_by_name(params[:name]))
    end
  end

  def price_search
    if Item.min_price(params[:min_price]).empty? && Item.max_price(params[:max_price]).empty?
      render json: { errors: "Couldn't find Item" }
    elsif Item.min_price(params[:min_price]).empty?
      render json: ItemSerializer.new(Item.max_price(params[:max_price]))
    elsif Item.max_price(params[:max_price]).empty?
      render json: ItemSerializer.new(Item.min_price(params[:min_price]))
    else
      render json: ItemSerializer.new(Item.min_price(params[:min_price]))
    end
  end
end