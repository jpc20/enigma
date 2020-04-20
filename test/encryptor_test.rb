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

  def test_it_can_encrypt_with_todays_date_and_no_key
    @encryptor.stubs(:todays_date).returns("040895")
    @encryptor.stubs(:generate_key).returns("02715")
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    assert_equal expected, @encryptor.encrypt("hello world")
  end

  def test_encrypt_message
    assert_equal "keder ohulw", @encryptor.encrypt_message("hello world", "02715", "040895")
  end

  def test_encrypt_character
    assert_equal "d", @encryptor.encrypt_character("a", 3)
    assert_equal "!", @encryptor.encrypt_character("!", 3)
  end

  def test_create_shifts
    assert_equal [3, 27, 73, 20], @encryptor.create_shifts("02715", "040895")
  end

end
