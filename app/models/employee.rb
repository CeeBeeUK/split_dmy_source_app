class Employee < ActiveRecord::Base
  extend TimeSplitter::Accessors
  extend SplitDmy::Accessors

  split_dmy_accessor :dob
  split_accessor :login
end
