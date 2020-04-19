require './test/test_helper'
require './lib/encryptor'

class EncryptorTest < Minitest::Test

  def setup
    @encryptor = Encryptor.new
  end

  def test_it_exists
    assert_instance_of Encryptor, @encryptor
  end

  def test_encrypt_when_given_a_date
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @encryptor.encrypt("hello world", "02715", "040895")
  end

  def test_it_can_encrypt_with_todays_date
    @encryptor.stubs(:todays_date).returns("040895")
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @encryptor.encrypt("hello world", "02715")
  end

  def test_encrypt_message
    assert_equal "keder ohulw", @encryptor.encrypt_message("hello world", "02715", "040895")
  end

  def test_encrypt_character
    assert_equal "d", @encryptor.encrypt_character("a", 3)
    assert_equal "!", @encryptor.encrypt_character("!", 3)
  end

  def test_split_message_groups_of_4
    assert_equal [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]], @encryptor.split_message("hello world")
  end

  def test_create_keys
    assert_equal [2, 27, 71, 15], @encryptor.split_key("02715")
  end

  def test_create_offsets_from_a_given_date
    assert_equal [1, 0, 2, 5], @encryptor.date_to_offsets("040895")
  end

  def test_find_the_shifts_from_the_key_and_date
    assert_equal [3, 27, 73, 20], @encryptor.create_shifts("02715", "040895")
  end

end
