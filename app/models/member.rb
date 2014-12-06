# == Schema Information
#
# Table name: members
#
#  id             :integer          not null, primary key
#  role_id        :integer
#  manager_id     :integer
#  name           :string(255)      not null
#  email          :string(255)      not null
#  gender         :string(10)
#  birthday       :date
#  designation    :string(50)
#  avtar          :string(255)
#  active         :boolean          default(FALSE)
#  last_logged_in :datetime
#  soft_delete    :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  team_id        :integer
#

class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutableand :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable


  # Validations
  validate :name, :presence => true, :uniqueness => true
  validates :email, presence: true
  validates_confirmation_of :password

  # Associations
  has_many :teams_members, 
          class_name: "TeamsMembers"
  has_many :teams, 
          :through => :teams_members, 
          :dependent => :destroy,
           :inverse_of => :members

  belongs_to :company, :inverse_of => :members
  belongs_to :role


  before_validation :assign_random_password, :if => lambda{|obj| obj.role?(Role.super_admin) },
                                             :on => :create
  before_create :admin_checks
  after_create :send_invite_to_admin


  def send_invite_to_admin
     AdminNotificationMailer.welcome_email(self.company, self).deliver! if self.role == Role.super_admin
  end

  rails_admin do
    field :name do
      label 'Admin Name'
    end
    field :email
    field :role_id, :enum do
      enum do
        [[Role.super_admin.name, Role.super_admin.id]] rescue []
      end
    end
    field :company do
      inverse_of :admin
    end
    field :teams do

    end
  end



  def assign_random_password
    random_password = "abrakadabra@12345"
    self.password = self.password_confirmation = random_password
  end

  def update_password_with_confirmation(params)
    Rails.logger.info "--> updating password"
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    return false if not valid?
    confirm!
    save
  end

  def role?(_role)
    self.role == _role
  end

  def admin_checks
    if self.role?(Role.super_admin)
      self.skip_confirmation_notification!
    else
      return
    end
  end


  def today_status
    Status.where("member_id = ? AND Date(created_at) = ?", self.id, Date.today).first
  end

  def super_admin?
    role == Role.super_admin
  end

  def member?
    role == Role.member
  end
end
