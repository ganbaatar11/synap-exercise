class CreateCheckin

  def self.call(person, event, weight, current_user)
    return if ENV['QUIET_MODE']
    previous_checkin = Checkin.where(person: person, event: event).last
    delta = nil
    delta = weight - previous_checkin.weight if previous_checkin
    Checkin.create(person: person, event: event, weight: weight, delta: delta, user: current_user)
    EventLeagueJoin.where(event_id: event, league_id: person.league_id).first_or_create
    # if current_user && !current_user.people.include?(person)
    #   current_user.user_person_joins.create(person: person)
    # elsif current_user && current_user.people.include?(person)
    #   join = current_user.user_person_joins.find_by(person: person)
    #   join.times_used += 1
    #   join.save
    # end
  end
end