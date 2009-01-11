namespace :crawler do

  desc "update all feeds"
  task :start => :environment do
    Crawler.new.start
  end

  desc "deliver new articles"
  task :deliver => :environment do 
    Crawler.new.deliver
  end

  desc "update all feeds and delivery news to users"
  task :run => :start do 
    Crawler.new.deliver
  end

end
