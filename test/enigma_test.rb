require './test/test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_has_an_alphabet
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @enigma.alphabet
  end

  def test_it_can_return_the_date
    assert_instance_of String, @enigma.todays_date
    assert_equal 6, @enigma.todays_date.length
    @enigma.stubs(:todays_date).returns("160420")
    assert_equal "160420", @enigma.todays_date
  end

  def test_it_can_generate_a_random_5_digit_key
    assert_instance_of String, @enigma.generate_key
    assert_equal 5, @enigma.generate_key.length
    assert_equal true, @enigma.generate_key.chars.all? { |char| char.to_i >= 0 && char.to_i < 10 }
  end

  def test_encrypt_when_given_a_date
  expected = {
    encryption: "keder ohulw",
    key: "02715",
    date: "040895"
  }
    assert_equal expected, @enigma.encrypt("hello world", "02715", "040895")
  end

  def test_it_can_decrypt_when_given_a_date
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @enigma.decrypt("keder ohulw", "02715", "040895")
  end

  def test_it_can_encrypt_with_todays_date
  @enigma.stubs(:todays_date).returns("040895")
  expected = {
    encryption: "keder ohulw",
    key: "02715",
    date: "040895"
  }
    assert_equal expected, @enigma.encrypt("hello world", "02715")
  end

  def test_decrypt_with_todays_date
    @enigma.stubs(:todays_date).returns("040895")
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @enigma.decrypt("keder ohulw", "02715")
  end

  def test_encrypt_message
    assert_equal "keder ohulw", @enigma.encrypt_message("hello world", "02715", "040895")
  end

  def test_decrypt_message
    assert_equal "hello world", @enigma.decrypt_message("keder ohulw", "02715", "040895")
  end

  def test_encrypt_with_a_random_key_and_todays_date
    @enigma.stubs(:todays_date).returns("040895")
    @enigma.stubs(:generate_key).returns("02715")
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @enigma.encrypt("hello world")
  end

  def test_split_message_groups_of_4
    assert_equal [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]], @enigma.split_message("hello world")
  end

  def test_encrypt_character
    assert_equal "d", @enigma.encrypt_character("a", 3)
    assert_equal "!", @enigma.encrypt_character("!", 3)
  end

  def test_decrypt_character
    assert_equal "a", @enigma.decrypt_character("d", 3)
    assert_equal "!", @enigma.decrypt_character("!", 3)
  end

  def test_create_keys
    assert_equal [2, 27, 71, 15], @enigma.split_key("02715")
  end

  def test_create_offsets_from_a_given_date
    assert_equal [1, 0, 2, 5], @enigma.date_to_offsets("040895")
  end

  def test_find_the_shifts_from_the_key_and_date
    assert_equal [3, 27, 73, 20], @enigma.create_shifts("02715", "040895")
  end

  def test_encrypt_with_characters_not_in_alphabet
    @enigma.stubs(:todays_date).returns("040895")
    @enigma.stubs(:generate_key).returns("02715")
    expected = {
      encryption: "keder ohulw!",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @enigma.encrypt("Hello World!")
  end

  def test_decrypt_with_characters_not_in_alphabet
    @enigma.stubs(:todays_date).returns("040895")
    expected = {
      decryption: "hello world!",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @enigma.decrypt("Keder Ohulw!", "02715")
  end

  def test_crack_encrypted_message_with_a_date
    expected =
  {
    decryption: "hello world end",
    date: "291018",
    key: "08304"
  }
    assert_equal expected, @enigma.crack("vjqtbeaweqihssi", "291018")
  end

  def test_crack_encrypted_message_witout_date
    @enigma.stubs(:todays_date).returns("291018")
    expected =
    {
      decryption: "hello world end",
      date: "291018",
      key: "08304"
    }

    assert_equal expected, @enigma.crack("vjqtbeaweqihssi")

    @enigma.stubs(:todays_date).returns("190420")
    expected =
    {
      decryption: "this is an 'very' important message.\nit needs to be encrypted!!! end",
      date: "190420",
      key: "14140"
    }
    assert_equal expected, @enigma.crack("mzwet fmuen'owek'rwzifefuegmfwfeuys.\n gmgwsqlrgattsmyeqdrggrx!!!twaq")
  end

  def test_find_key_with_date_and_encrypted_message
    assert_equal "08304", @enigma.find_key("vjqtbeaweqihssi", "291018")

    assert_equal "14140", @enigma.find_key("mzwet fmuen'owek'rwzifefuegmfwfeuys.
     gmgwsqlrgattsmyeqdrggrx!!!twaq", "190420")
    assert_equal "20258", @enigma.find_key("sjuwzkdd pl'ugcb'buqoqcx pedlgdw iq.
    kedmgqhrbeszdqddpovxreic!!!zgzh", "190420")
  end

  def test_find_first_key
    assert_equal "08", @enigma.find_first_key(14, 6)
    assert_equal "20", @enigma.find_first_key(26, 6)
  end

  def test_find_next_key_value
    key = "08"
    @enigma.find_next_key_value(key, 1, 3, 5)
    assert_equal "083", key
  end

  def test_find_shifts_with_date_and_encrypted_message
    assert_equal [14, 5, 5, 8], @enigma.find_shifts("vjqtbeaweqihssi", "291018")
  end

  def test_shifts_for_multiple_of_4
    end_array = [" ", "e", "n", "d"]
    split_message = @enigma.split_message("wvjqtbeaweqihssi")
    assert_equal [8, 14, 5, 5], @enigma.shifts_for_multiple_of_4(split_message, end_array)
  end

  def test_shifts_for_less_than_4_chars
    end_array = [" ", "e", "n", "d"]
    split_message = @enigma.split_message("vjqtbeaweqihssi")
    last_chars_length = split_message.last.length
    assert_equal [14, 5, 5, 8], @enigma.shifts_for_less_than_4_chars(split_message, end_array, last_chars_length)
  end

  def test_find_shift_amount
    assert_equal 8, @enigma.shift_amount("h", " ")
    assert_equal 14, @enigma.shift_amount("s", "e")
  end

end
