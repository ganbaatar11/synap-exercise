class LeaguesController < ApplicationController
  def show
    @league = League.find_by(id: params[:id])
    @event = Event.find(params[:event_id])
    @people = @league.people
    @people.each do |person|
      person.set_starting_weight(@event)
      person.up_by = person.up_by(@event)
    end
  end

  def create
    @league = League.create!(league_params)
    redirect_to new_person_path
  rescue
    flash[:error] = "Please fill out all fields"
    redirect_to new_league_path
  end

  private
  def league_params
    params.required(:league).permit([:name])
  end
end
