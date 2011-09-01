module UserHelper
  def user_block(user)
    render :partial => "home/snippets/user_li", :locals => {  :user => user }
  end
  
end