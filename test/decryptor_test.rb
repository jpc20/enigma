require './test/test_helper'
require './lib/decryptor'

class DecryptorTest < Minitest::Test

  def setup
    @decryptor = Decryptor.new
  end

  def test_it_exists
    assert_instance_of Decryptor, @decryptor
  end
end
