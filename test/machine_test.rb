require './test/test_helper'
require './lib/machine'

class MachineTest < Minitest::Test

  def setup
    @machine = Machine.new
  end

  def test_it_exists
    assert_instance_of Machine, @machine
  end

  def test_it_has_an_alphabet
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @machine.alphabet
  end

  def test_it_can_return_the_date
    assert_instance_of String, @machine.todays_date
    assert_equal 6, @machine.todays_date.length
    @machine.stubs(:todays_date).returns("160420")
    assert_equal "160420", @machine.todays_date
  end
end
