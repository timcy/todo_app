class List < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |t| t[:description].blank? }, :allow_destroy => true
end