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

  def test_message_groups_of_4
    assert_equal [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]], @enigma.split_message("hello world")
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

end
