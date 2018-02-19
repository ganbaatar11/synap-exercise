class Person < ActiveRecord::Base

  has_many :checkins
  has_many :user_person_joins
  has_many :users, through: :user_person_joins
  belongs_to :league

  validates :name, presence: true, length: { minimum: 2 }
  validates :league_id, presence: true, numericality: true

  def up_by(event=nil)
    return attributes['up_by'] unless event
    checkins_from_event = event.checkins.where(person: self).order(:id)
    first_checkin = checkins_from_event.first
    last_checkin = checkins_from_event.last
    last_checkin == first_checkin ? nil : last_checkin.weight - first_checkin.weight
  end

  def percentage_change
    return unless up_by
    @percentage_change ||= starting_weight ? up_by.to_f / starting_weight * 100 : nil
  end

  def checkin_diffs
    grouped = checkins.includes(:event).order('events.created_at').group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, event_checkins|
      diffs = event_checkins.sort_by(&:id).map(&:delta).compact
      event_diffs[event.try(:name)] = diffs.map {|d| '%.2f' % d}
    end
    event_diffs
  end

  def set_starting_weight(event=nil)
    return unless event
    checkins_from_event = event.checkins.where(person: self).order(:created_at).first
    self.starting_weight = checkins_from_event.weight if checkins_from_event.present?
  end
end
