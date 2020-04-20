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

  def test_decrypt_with_todays_date
    @decryptor.stubs(:todays_date).returns("040895")
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @decryptor.decrypt("keder ohulw", "02715")
  end

  def test_decrypt_with_characters_not_in_alphabet
    @decryptor.stubs(:todays_date).returns("040895")
    expected = {
      decryption: "hello world!",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @decryptor.decrypt("Keder Ohulw!", "02715")
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

  def test_find_key_with_date_and_encrypted_message
    assert_equal "08304", @decryptor.find_key("vjqtbeaweqihssi", "291018")
    assert_equal "14140", @decryptor.find_key("mzwet fmuen'owek'rwzifefuegmfwfeuys.
     gmgwsqlrgattsmyeqdrggrx!!!twaq", "190420")
    assert_equal "14811", @decryptor.find_key("mfictgskul 'ocri'yiximrdultkfcscuee.
    gtkgceolytzt ekylcbrntpx!!!tcno", "200420")
  end


  def test_find_all_potential_keys
    expected = {0=>["08", "35", "62", "89"], 1=>["02", "29", "56", "83"], 2=>["03", "30", "57", "84"], 3=>["04", "31", "58", "85"]}
    assert_equal expected, @decryptor.find_all_potential_keys("vjqtbeaweqihssi", "291018")
  end

  def test_find_working_keys
    assert_equal ["08", "83", "30", "04"], @decryptor.find_working_keys("vjqtbeaweqihssi", "291018")
  end

  def test_combine_keys
    assert_equal "08304", @decryptor.combine_keys(["08", "83", "30", "04"])
  end

  def test_key_is_valid
    assert_equal true, @decryptor.key_is_valid?(["02", "29", "56", "83"], "08")
    assert_equal false, @decryptor.key_is_valid?(["02", "29", "56", "83"], "89")
  end

  def test_find_next_valid_key
    assert_equal "83", @decryptor.find_next_valid_key(["02", "29", "56", "83"], "08")
  end

  def test_calculate_possible_key_values
    assert_equal ["01", "28", "55", "82"], @decryptor.calculate_possible_key_values(1)
  end

  def test_first_key_value
    assert_equal "09", @decryptor.first_key_value(9)
    assert_equal "12", @decryptor.first_key_value(12)
  end

  def test_shifts_minus_offsets_when_finding_potential_keys
    assert_equal [8, 2, 3, 4], @decryptor.shifts_minus_offsets("vjqtbeaweqihssi", "291018")
  end

end
