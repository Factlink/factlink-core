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

   field :first_name
   field :last_name

   field :url

   # twitter, facebook...
   field :social_accounts, :type => Array
   
   # validates_format_of :url, :with => URI::regexp(%w(http https))

end