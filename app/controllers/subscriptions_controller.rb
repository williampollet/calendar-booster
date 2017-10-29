class SubscriptionsController < ApplicationController
  include ApplicationHelper

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def create
    subscription = GoogleCalendarService.new(user: current_user).subscribe
    Subscription.create!(
      kind: subscription["kind"],
      user_id: current_user.id,
      google_uuid: subscription["id"],
      google_resource_id: subscription["resourceId"],
      google_resource_uri: subscription["resourceUri"],
      expiration: subscription["expiration"]
    )
    redirect_to subscriptions_path
  end

  def index
    @subscriptions = Subscription.where(user_id: current_user.id, is_active: true)
  end

  def destroy
    subscription = Subscription.find(params[:id])
    GoogleCalendarService.new(user: current_user).
      unsubscribe(subscription: subscription)
    subscription.update!(is_active: false)
    redirect_to subscriptions_path
  end
end
