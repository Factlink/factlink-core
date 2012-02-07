class AddAgreedTosOn < Mongoid::Migration

  def self.date_obj str
   DateTime.strptime str+" +0100", '[%d/%b/%Y:%H:%M:%S %Z'
  end

  def self.up
    # Data extracted from nginx access log on beta.factlink.com, Feb 6 2012
    # We only took requests with status 302, implying agreeing with the ToS
    arr = [{:username=>"mark", :date=>"[28/Dec/2011:10:46:44"},
     {:username=>"merijn", :date=>"[28/Dec/2011:11:09:27"},
     {:username=>"salvador", :date=>"[28/Dec/2011:11:21:05"},
     {:username=>"joel", :date=>"[28/Dec/2011:11:43:33"},
     {:username=>"jordin", :date=>"[29/Dec/2011:14:13:24"},
     {:username=>"remon", :date=>"[05/Jan/2012:18:46:02"},
     {:username=>"tom", :date=>"[03/Jan/2012:10:40:20"},
     {:email=>"g.smit@forgia.nl", :date=>"[29/Dec/2011:14:13:28"},
     {:email=>"knud.balslev@gmail.com", :date=>"[30/Dec/2011:03:00:27"},
     {:email=>"jp.posma@gmail.com", :date=>"[31/Dec/2011:16:59:53"},
     {:email=>"g33rtjan@gmail.com", :date=>"[02/Jan/2012:20:54:27"},
     {:email=>"marten@veldthuis.com", :date=>"[05/Jan/2012:12:26:31"},
     {:email=>"gertjan@solidsquare.nl", :date=>"[05/Jan/2012:16:33:59"},
     {:email=>"bzijlema@gmail.com", :date=>"[08/Jan/2012:13:14:32"},
     {:email=>"m.prins@online24.nl", :date=>"[11/Jan/2012:15:46:36"},
     {:email=>"mheijkoop@gmail.com", :date=>"[24/Jan/2012:17:14:27"},
     {:email=>"alleijbema@gmail.com", :date=>"[24/Jan/2012:22:00:58"},
     {:email=>"jjpijpker@gmail.com", :date=>"[25/Jan/2012:11:09:56"},
     {:email=>"c.j.kramer@student.utwente.nl", :date=>"[25/Jan/2012:11:58:14"},
     {:email=>"lykle@deondernemers.nl", :date=>"[25/Jan/2012:14:27:37"},
     {:email=>"jansenkim83@gmail.com", :date=>"[29/Jan/2012:14:44:00"},
     {:email=>"martijn@russchenmedia.nl", :date=>"[01/Feb/2012:11:14:54"},
     {:email=>"ijsbeertje@hotmail.com", :date=>"[02/Feb/2012:10:32:13"},
     {:email=>"bobbrink@gmail.com", :date=>"[03/Feb/2012:12:06:06"},
     {:email=>"irissen88@hotmail.com", :date=>"[05/Feb/2012:20:54:39"}]

    arr.map { |u| u[:date] = date_obj u[:date] }

    say_with_time "Adding agreed_tos_on datetime to existing users" do
      arr.each do |user|
        found = User.where(user.slice(:email,:username))
        if found.count == 1
          u = found.first
          u.agreed_tos_on = user[:date]
          u.save
        else
          puts "expected to find one user, instead found #{found.count} when searching for #{user.slice(:email,:username)}"
          puts "we found: #{found.to_a}"
        end
      end
    end
  end

  def self.down
  end
end