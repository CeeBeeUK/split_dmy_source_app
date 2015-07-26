require_relative '../../lib/split_dmy/split_accessors'

class Manager < ActiveRecord::Base
  extend SplitDmy::SplitAccessors
  split_dmy_accessor :date_of_birth
end
