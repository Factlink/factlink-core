class GithubIssue
  include Octopi

  def body_for issue
    body = "Reported by: "
    body += if issue[:reporter][:user]
              issue[:reporter][:user] + "(#{issue[:reporter][:email]})"
            else
              issue[:reporter][:email]
            end
    body += "\n\n"
    body+= issue[:content]
    body
  end

  def report(issue)
    authenticated_with :login => "factlink-feedback", :token => "5bbd77b68c0f8e5a487e3f8d3c272764" do
      repo = Repository.find(:name => "feedback", :user => "Factlink")

      gh_issue = Issue.open :repo => repo, :params => {
        :title => issue[:subject],
        :body => body_for(issue)
      }
      gh_issue.add_label "user_feedback"
    end
  end
end
