module TeamHelper
  def linkedin_icon_for_team_member handle, team_member
    url = handle.match(/^http/) ? handle : "http://www.linkedin.com/in/#{handle}"
    link_to content_tag(:i, "Linkedin"), url, class: "ico linkedin", target: "_blank", title: "#{team_member}'s LinkedIn"
  end

  def twitter_icon_for_team_member handle, team_member
    twitter_url = handle.match(/^http/) ? handle : "http://www.twitter.com/#{handle}"
    link_to content_tag(:i, "Twitter"), twitter_url, class: "ico twitter", target: "_blank", title: "#{team_member}'s Twitter"
  end

  def team_photo_tag photo, name, linkedin=nil, twitter=nil
    html = image_tag "team/#{photo}.jpg", alt: name, class: "img-circle team-photo", rel: "tooltip", title: name, width: 135, height: 135
    html += linkedin_icon_for_team_member linkedin, name if linkedin
    html += twitter_icon_for_team_member twitter, name   if twitter

    content_tag "div", html, class: "span3 team-member"
  end

  def advisor_photo_tag photo, name, linkedin=nil
    content_tag "div", class: "span2 team-member" do
      image_tag "team/#{photo}.jpg", alt: name, class: "img-circle team-photo", rel: "tooltip", title: name, width: 80, height: 80
    end
  end
end
