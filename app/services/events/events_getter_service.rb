class Events::EventsGetterService
  def initialize(user:)
    @user = user
    @calendar_service = GoogleCalendarService.new(user: user).service
    @events_creator = Events::CreateOrUpdateService.new
    @events = []
  end

  def synchronize_calendar(full_sync: false)
    if @user.sync_token.nil? || full_sync
      sync_events
    else
      sync_events(sync_token: @user.sync_token)
    end
    @events
  end

  private

  def full_sync
    events = sync_events_batch
    while events.next_page_token do
      events = sync_events_batch(next_page_token: @user.sync_token)
    end
  end

  def sync_events(sync_token: nil, page_token: nil)
    # get the batch thanks to calendar service
    events = @calendar_service.list_events(
      @user.email,
      sync_token: sync_token,
      page_token: page_token
    )

    # store the events in the DB
    events.items.compact.each do |e|
      item = @events_creator.create_or_update(event: e, user: @user)
      puts item
      @events << item
    end

    if (token = events.next_page_token).present?
      events = sync_events(page_token: token)
    elsif (token = events.next_sync_token).present?
      # update the token of the user
      @user.update!(sync_token: token)
    end
    events
  end
end
