require './test/test_helper'
require './lib/code_breaker'

class CodeBreakerTest < Minitest::Test

  def setup
    @code_breaker = CodeBreaker.new
  end

  def test_it_exists
    assert_instance_of CodeBreaker, @code_breaker
  end
end
