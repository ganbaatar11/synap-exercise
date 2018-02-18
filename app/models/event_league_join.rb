class EventLeagueJoin < ActiveRecord::Base
  belongs_to :event
  belongs_to :league
end