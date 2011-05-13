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

  attr_accessor :invite_code

  validate :doit
  
  def doit

    unless age_from.nil? and age_from.nil?
      if age_from > age_till
        errors.add(:age_till, 'moet groter zijn dan [age_from]')
      end
    end
    
  end
  
  # validates_each :invite_code, :on => :create do |record, attr, value|
  #   errors.add("Invalid invite code.") unless 
  #     value && value == "12345"
    
    
    # record.errors.add attr, "Please enter correct invite code" unless
    #   value && value == "12345"
  # end
  
end