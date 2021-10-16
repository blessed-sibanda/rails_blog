class SubscriptionsController < ApplicationController
  before_action :set_author

  def update
    Subscription.create!(user: current_user, author: @author)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_author
    @author = User.find(params[:id])
  end
end
