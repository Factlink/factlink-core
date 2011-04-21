class Admin
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :recoverable, :confirmable, :registerable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, :trackable, :validatable

end
