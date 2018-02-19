# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
require 'set'

leagues = {}
events = {}
people = {}

participants = CSV.read("participants.csv")
weighins = CSV.read("weighins.csv")

participants.map{|row| row[2]}.to_set.each{|l| leagues[l] = League.create(name: l).id if l != 'League'}
participants.map{|row| [row[1], row[3]]}.to_set.each{|e| events[e[0]] = Event.create(name: e[0], tagline: e[0], created_at: Time.strptime(e[1], '%m/%d/%Y')).id if e[0] != 'Event'}
participants.map{|row| [row[0], row[2]]}.to_set.each{|p| people[p[0]] = Person.create(name: p[0], league_id: leagues[p[1]]).id if p[0] != 'Name'}

p = 0
wh = 0
ev = 0
d = 0
l = 0

weighins.each do |w|
  if w[0] != 'Name'
    if p == people[w[0]] and ev == events[w[2]]
      d = w[1].to_i - wh
    else
      ev = events[w[2]]
      d = 0
      p = people[w[0]]
      l = leagues[w[0]]
    end
    wh = w[1].to_i

    l_id = Person.select(:league_id).find_by(name: w[0]).league_id
    Checkin.create(weight: wh, person_id: p, created_at: w[3], event_id: ev, delta: d)
    EventLeagueJoin.where(event_id: ev, league_id: l_id).first_or_create
  end

end