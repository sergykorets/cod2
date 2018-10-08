class ReviewsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: :destroy
  before_action :define_hotel
  before_action :set_review, only: :destroy

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.try(:id)
    @review.hotel_id = @hotel.id
    if @review.save
      update_hotel_rating(@hotel)
      render json: {success: true}
    else
      session[:review_url] = Rails.env.development? ?
                               hotel_path(@hotel, comment: review_params[:comment]) :
                               "https://dragobrat.herokuapp.com/hotels/#{@hotel.id}?comment=#{review_params[:comment]}"
      render json: {success: false}
    end
  end

  def destroy
    @review.destroy if current_user.id == @review.user_id
    update_hotel_rating(@hotel)
    if @review.destroyed?
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def define_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
