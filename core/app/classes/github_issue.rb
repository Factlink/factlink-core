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
    authenticated_with :login => "factlink-feedback", :token => "9ebbc1d9ea9bd7762bcee08448a49d34" do
      repo = Repository.find(:name => "feedback", :user => "Factlink")

      gh_issue = Issue.open :repo => repo, :params => {
        :title => issue[:subject],
        :body => body_for(issue)
      }
      gh_issue.add_label "user_feedback"
    end
  end
end
