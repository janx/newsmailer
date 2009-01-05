namespace :feed do
  desc "clear all subscriptions"
  task :clear => :environment do
    count = Feed.count
    Feed.delete_all
    puts "#{count} feeds removed"
  end
end
