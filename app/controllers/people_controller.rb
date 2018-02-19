class PeopleController < ApplicationController
  def new
    @leagues = League.all.order(:name)
  end

  def create
    @person = Person.create!(person_params)
    redirect_to people_path
  rescue
    flash[:error] = "Please fill out all fields"
    redirect_to new_person_path
  end

  def index
    @event = Event.last
    redirect_to new_event_path unless @event
    @event = Event.last
    @people = @event.people
    @people.each do |person|
      person.set_starting_weight(@event)
      person.up_by = person.up_by(@event)
    end
    @leagues = {}
    @event.leagues.each{|l| @leagues[l.id] = l.name}
  end

  def show
    @person = Person.find(params[:id])
  end

  private
  def person_params
    params.required(:person).permit([:name, :league_id])
  end

  def checkin_params
    params.required(:person).permit([:weight])
  end
end