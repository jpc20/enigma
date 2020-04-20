require './test/test_helper'
require './lib/key_finder'

class KeyFinderTest < Minitest::Test

  def setup
    @key_finder = Keyfinder.new
  end

  def test_it_exists
    assert_instance_of Keyfinder, @key_finder
  end
end
