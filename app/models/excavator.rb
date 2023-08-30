class Excavator < ApplicationRecord
  belongs_to :ticket

  validates :phone_no, :email, presence: true
end
