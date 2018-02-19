class League < ActiveRecord::Base
  has_many :people
  has_many :event_league_join
  has_many :events, -> { distinct }, through: :event_league_join

  validates :name, presence: true, length: { minimum: 2 }, uniqueness: { case_sensitive: false }
end
