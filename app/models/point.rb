class Point < ActiveRecord::Base
  belongs_to :user
  belongs_to :option
  belongs_to :position
  has_many :inclusions
  
  acts_as_paranoid_versioned
  
  cattr_reader :per_page
  @@per_page = 4  
  
  scope :pros, where( :is_pro => true )
  scope :cons, where( :is_pro => false )

end
