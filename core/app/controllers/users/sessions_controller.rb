class Users::SessionsController < Devise::SessionsController
  
  layout "accounting"

  def new
    puts "\n\n\n:::::::\nNew session\n\n\n"
    super
  end
  
  def create
    puts "\n\n\n:::::::\nCreating session\n\n\n"
    super
  end
  
  def destroy
    puts "\n\n\n:::::::\nDestroying session\n\n\n"
    super
  end
  
end