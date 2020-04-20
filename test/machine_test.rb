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

  def test_create_keys
    assert_equal [2, 27, 71, 15], @machine.split_key("02715")
  end

  def test_create_offsets_from_a_given_date
    assert_equal [1, 0, 2, 5], @machine.date_to_offsets("040895")
  end

  def test_find_the_shifts_from_the_key_and_date
    assert_equal [3, 27, 73, 20], @machine.create_shifts("02715", "040895")
  end

  def test_split_message_groups_of_4
    assert_equal [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]], @machine.split_message("hello world")
  end

  def test_find_shift_amount
    assert_equal 8, @machine.shift_amount("h", " ")
    assert_equal 14, @machine.shift_amount("s", "e")
  end

end
