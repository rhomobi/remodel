require 'rubygems'
require 'test/unit'
require 'shoulda'

require File.dirname(__FILE__) + '/../lib/remodel-h.rb'

class Test::Unit::TestCase

  def redis
    Remodel.redis
  end
  
end
