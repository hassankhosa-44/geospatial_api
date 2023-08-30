require 'test_helper'

class ExcavatorTest < ActiveSupport::TestCase
  def setup
    @excavator = excavators(:one)
  end

  test 'should belong to a ticket' do
    assert_instance_of Ticket, @excavator.ticket
  end

  test 'email should be present' do
    @excavator.email = ''
    assert_not @excavator.valid?
    assert_includes @excavator.errors[:email], "can't be blank"
  end

  test 'phone_no should be present' do
    @excavator.phone_no = nil
    assert_not @excavator.valid?
    assert_includes @excavator.errors[:phone_no], "can't be blank"
  end
end
