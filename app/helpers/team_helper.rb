module TeamHelper
  def team_photo_tag photo, name, factlink_profile
    html = link_to "https://factlink.com/#{factlink_profile}", title: "#{name}'s #{I18n.t(:app_name)} Profile" do
      html = image_tag "team/#{photo}.jpg", alt: name, class: "team-photo", rel: "tooltip", title: name
    end
    html += content_tag "div", name, class: "team-member-name"

    content_tag "li", html, class: "team-member-block"
  end

  def advisor_photo_tag photo, name
    html = image_tag "team/#{photo}.jpg", alt: name, class: "team-photo advisor", rel: "tooltip", title: name
    html += content_tag "div", name, class: "team-advisor-name"

    content_tag "li", html, class: "team-advisor-block"
  end
end
