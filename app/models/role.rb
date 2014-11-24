# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  active      :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Role < ActiveRecord::Base
  
  # Validations
  validates :name, :uniqueness => true, :presence => true

  # Associations
  has_many :members

  # Scopes
  scope :super_admin, ->{ where(name: 'Super Admin').first }
  scope :admin,       ->{ where(name: 'Admin').first }
  scope :member,      ->{ where(name: 'Member').first }


end
