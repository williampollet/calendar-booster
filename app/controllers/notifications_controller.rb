class NotificationsController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    subscription = Subscription.find_by_google_uuid(request.headers["HTTP_X_GOOG_CHANNEL_ID"])
    user = subscription.user
    events = Events::EventsGetterService.new(user: user).synchronize_calendar
    # before changing anything refactor this service (which is not object oriented)
    unless events.empty?
      validator = ActionnableEventsValidator.new
      events.each do |e|
        if validator.validates?(e)[:ok]
          Trajects::CreateTrajectService.new(user: user).perform(trigger_event: e)
        end
      end
    end

    head 200, content_type: "application/json"
  end
end
