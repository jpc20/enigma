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

  def test_decrypt_character
    assert_equal "a", @decryptor.decrypt_character("d", 3)
    assert_equal "!", @decryptor.decrypt_character("!", 3)
  end
end
