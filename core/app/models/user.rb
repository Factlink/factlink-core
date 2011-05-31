class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :registerable,
  devise  :database_authenticatable, 
          :recoverable, 
          :rememberable, 
          :trackable, 
          :validatable,
          :registerable

  field :name       # Display name
  field :first_name # 
  field :last_name

  field :url

  field :verified, :type => Boolean, :default => false
   
  # twitter, facebook...
  field :social_accounts, :type => Array

  
end