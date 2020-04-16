require './test/test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_can_encrypt_when_given_a_date
  skip
  expected = {
    encryption: "keder ohulw",
    key: "02715",
    date: "040895"
  }
    assert_equal expected, @enigma.encrypt("hello world", "02715", "040895")
  end

  def test_it_can_decrypt_when_given_a_date
    skip
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @enigma.decrypt("keder ohulw", "02715", "040895")
  end

  def test_it_can_encrypt_with_todays_date
    skip
  expected = {
    encryption: "keder ohulw",
    key: "02715",
    date: "040895"
  }
    assert_equal expected, @enigma.encrypt("hello world", "02715")
  end

  def test_it_can_decrypt_with_todays_date
    skip
    expected = {
          decryption: "hello world",
          key: "02715",
          date: "040895"
    }
    assert_equal expected, @enigma.decrypt("keder ohulw", "02715")
  end

  def test_it_can_encrypt_with_a_random_key_and_todays_date
    skip
    assert_equal expected, @enigma.encrypt("hello world")
  end

  def test_it_can_create_keys
    assert_equal ['02', '27', '71', '15'], @enigma.split_key("02715")
  end

  def test_it_can_create_offsets_from_a_given_date
    assert_equal ["1", "0", "2", "5"], @enigma.date_to_offsets("040895")
  end

end
