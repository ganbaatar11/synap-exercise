class League < ActiveRecord::Base
  has_many :people
  has_many :event_league_join
  has_many :events, -> { distinct }, through: :event_league_join
end
