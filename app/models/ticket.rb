class Ticket < ApplicationRecord
  has_one :excavator
  validates :request_number, presence: true, uniqueness: true
end
