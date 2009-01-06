namespace :crawler do

  desc "update all feeds"
  task :start => :environment do
    Feed.all.each do |feed|
      puts "Fetching #{feed.name} ..."
      feed.refresh
    end
  end

  desc "deliver new articles"
  task :deliver => :environment do 
    deliver
  end

  desc "update all feeds and delivery news to users"
  task :run => :start do 
    deliver
  end

  def deliver
    User.all.each do |user|
      user.news.each do |article|
        article.send_to user
      end
      user.update_attribute :delivered_at, Time.now
    end
  end

end
