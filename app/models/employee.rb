class Employee < ActiveRecord::Base
  extend TimeSplitter::Accessors
  extend SplitDateDmy::Accessors

  split_accessor :login
  split_dmy_accessor :dob

end
