class EventsController < ApplicationController
  def index
    @events = Event.all.order(:id).reverse
  end

  def show
    @leagues = {}
    @event = Event.find(params[:id])
    @people = @event.people
    @people.each do |person|
      person.set_starting_weight(@event)
      person.up_by = person.up_by(@event)
    end
    @event.leagues.each{|l| @leagues[l.id] = l.name}
  end

  def create
    @event = Event.create(event_params)
    redirect_to people_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :tagline)
  end
end
