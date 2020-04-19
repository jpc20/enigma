require './test/test_helper'
require './lib/encryptor'

class EncryptorTest < Minitest::Test

  def setup
    @encryptor = Encryptor.new
  end

  def test_it_exists
    assert_instance_of Encryptor, @encryptor
  end
end
