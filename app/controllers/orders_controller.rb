class OrdersController < ApplicationController
  def index
    Order.limit(10)
  end

  def import
    Order.import(params[:file])
  end
end
