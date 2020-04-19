require './test/test_helper'
require './lib/decryptor'

class DecryptorTest < Minitest::Test

  def setup
    @decryptor = Decryptor.new
  end

  def test_it_exists
    assert_instance_of Decryptor, @decryptor
  end

  def test_it_can_decrypt_when_given_a_date
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @decryptor.decrypt("keder ohulw", "02715", "040895")
  end

  def test_decrypt_message
    assert_equal "hello world", @decryptor.decrypt_message("keder ohulw", "02715", "040895")
  end

  def test_crack_encrypted_message_with_a_date
    expected =
  {
    decryption: "hello world end",
    date: "291018",
    key: "08304"
  }
    assert_equal expected, @decryptor.crack("vjqtbeaweqihssi", "291018")
  end

  def test_crack_message
    assert_equal "hello world end", @decryptor.crack_message("vjqtbeaweqihssi", "291018")
  end

  def test_decrypt_character
    assert_equal "a", @decryptor.decrypt_character("d", 3)
    assert_equal "!", @decryptor.decrypt_character("!", 3)
  end

  def test_find_shifts_with_date_and_encrypted_message
    assert_equal [14, 5, 5, 8], @decryptor.find_shifts("vjqtbeaweqihssi", "291018")
  end

  def test_shifts_for_multiple_of_4
    end_array = [" ", "e", "n", "d"]
    split_message = @decryptor.split_message("wvjqtbeaweqihssi")
    assert_equal [8, 14, 5, 5], @decryptor.shifts_for_multiple_of_4(split_message, end_array)
  end

  def test_shifts_for_less_than_4_chars
    end_array = [" ", "e", "n", "d"]
    split_message = @decryptor.split_message("vjqtbeaweqihssi")
    last_chars_length = split_message.last.length
    assert_equal [14, 5, 5, 8], @decryptor.shifts_for_less_than_4_chars(split_message, end_array, last_chars_length)
  end

  def test_find_shift_amount
    assert_equal 8, @decryptor.shift_amount("h", " ")
    assert_equal 14, @decryptor.shift_amount("s", "e")
  end

  def test_find_key_with_date_and_encrypted_mressage
    assert_equal "08304", @decryptor.find_key("vjqtbeaweqihssi", "291018")

    assert_equal "14140", @decryptor.find_key("mzwet fmuen'owek'rwzifefuegmfwfeuys.
     gmgwsqlrgattsmyeqdrggrx!!!twaq", "190420")
    assert_equal "20258", @decryptor.find_key("sjuwzkdd pl'ugcb'buqoqcx pedlgdw iq.
    kedmgqhrbeszdqddpovxreic!!!zgzh", "190420")
  end

  def test_find_first_key
    assert_equal "08", @decryptor.find_first_key(14, 6)
    assert_equal "20", @decryptor.find_first_key(26, 6)
  end

  def test_find_next_key_value
    key = "08"
    @decryptor.find_next_key_value(key, 1, 3, 5)
    assert_equal "083", key
  end

end
