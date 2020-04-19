require './test/test_helper'
require './lib/code_breaker'

class CodeBreakerTest < Minitest::Test

  def setup
    @code_breaker = CodeBreaker.new
  end

  def test_it_exists
    assert_instance_of CodeBreaker, @code_breaker
  end

  def test_crack_encrypted_message_with_a_date
    expected =
  {
    decryption: "hello world end",
    date: "291018",
    key: "08304"
  }
    assert_equal expected, @code_breaker.crack("vjqtbeaweqihssi", "291018")
  end

  def test_crack_message
    assert_equal "hello world end", @code_breaker.crack_message("vjqtbeaweqihssi", "291018")
  end

  def test_find_shifts_with_date_and_encrypted_message
    assert_equal [14, 5, 5, 8], @code_breaker.find_shifts("vjqtbeaweqihssi", "291018")
  end

  def test_shifts_for_multiple_of_4
    end_array = [" ", "e", "n", "d"]
    split_message = @code_breaker.split_message("wvjqtbeaweqihssi")
    assert_equal [8, 14, 5, 5], @code_breaker.shifts_for_multiple_of_4(split_message, end_array)
  end

  def test_shifts_for_less_than_4_chars
    end_array = [" ", "e", "n", "d"]
    split_message = @code_breaker.split_message("vjqtbeaweqihssi")
    last_chars_length = split_message.last.length
    assert_equal [14, 5, 5, 8], @code_breaker.shifts_for_less_than_4_chars(split_message, end_array, last_chars_length)
  end

  def test_find_shift_amount
    assert_equal 8, @code_breaker.shift_amount("h", " ")
    assert_equal 14, @code_breaker.shift_amount("s", "e")
  end

  def test_find_key_with_date_and_encrypted_mressage
    assert_equal "08304", @code_breaker.find_key("vjqtbeaweqihssi", "291018")

    assert_equal "14140", @code_breaker.find_key("mzwet fmuen'owek'rwzifefuegmfwfeuys.
     gmgwsqlrgattsmyeqdrggrx!!!twaq", "190420")
    assert_equal "20258", @code_breaker.find_key("sjuwzkdd pl'ugcb'buqoqcx pedlgdw iq.
    kedmgqhrbeszdqddpovxreic!!!zgzh", "190420")
  end

  def test_find_first_key
    assert_equal "08", @code_breaker.find_first_key(14, 6)
    assert_equal "20", @code_breaker.find_first_key(26, 6)
  end

  def test_find_next_key_value
    key = "08"
    @code_breaker.find_next_key_value(key, 1, 3, 5)
    assert_equal "083", key
  end

end
