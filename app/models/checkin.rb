class Checkin < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :user

  validates :person_id, presence: true, length: { minimum: 2 }
  validates :weight, presence: true, numericality: true

end
