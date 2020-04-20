require './test/test_helper'
require './lib/key_finder'

class KeyFinderTest < Minitest::Test

  def setup
    @key_finder = Keyfinder.new
  end

  def test_it_exists
    assert_instance_of Keyfinder, @key_finder
  end

  def test_find_key_with_date_and_encrypted_message
    assert_equal "08304", @key_finder.find_key("vjqtbeaweqihssi", "291018")
    assert_equal "14140", @key_finder.find_key("mzwet fmuen'owek'rwzifefuegmfwfeuys.
     gmgwsqlrgattsmyeqdrggrx!!!twaq", "190420")
    assert_equal "14811", @key_finder.find_key("mfictgskul 'ocri'yiximrdultkfcscuee.
    gtkgceolytzt ekylcbrntpx!!!tcno", "200420")
  end


  def test_find_all_potential_keys
    expected = {0=>["08", "35", "62", "89"], 1=>["02", "29", "56", "83"], 2=>["03", "30", "57", "84"], 3=>["04", "31", "58", "85"]}
    assert_equal expected, @key_finder.find_all_potential_keys("vjqtbeaweqihssi", "291018")
  end

  def test_find_working_keys
    assert_equal ["08", "83", "30", "04"], @key_finder.find_working_keys("vjqtbeaweqihssi", "291018")
  end

  def test_combine_keys
    assert_equal "08304", @key_finder.combine_keys(["08", "83", "30", "04"])
  end

  def test_key_is_valid
    assert_equal true, @key_finder.key_is_valid?(["02", "29", "56", "83"], "08")
    assert_equal false, @key_finder.key_is_valid?(["02", "29", "56", "83"], "89")
  end

  def test_find_next_valid_key
    assert_equal "83", @key_finder.find_next_valid_key(["02", "29", "56", "83"], "08")
  end

  def test_calculate_possible_key_values
    assert_equal ["01", "28", "55", "82"], @key_finder.calculate_possible_key_values(1)
  end

  def test_first_key_value
    assert_equal "09", @key_finder.first_key_value(9)
    assert_equal "12", @key_finder.first_key_value(12)
  end

  def test_shifts_minus_offsets_when_finding_potential_keys
    assert_equal [8, 2, 3, 4], @key_finder.shifts_minus_offsets("vjqtbeaweqihssi", "291018")
  end
end
