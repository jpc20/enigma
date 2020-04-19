require './test/test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
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

end
