
namespace :crawler do
  desc "update all feeds"
  task :start => :environment do
    Feed.all.each do |feed|
      puts "Fetching #{feed.name} ..."
      feed.refresh
    end
  end

  desc "delivery news to users"
  task :run => :start do
    User.all.each do |user|
      user.news.each {|article| article.send_to user}
    end
  end
end
