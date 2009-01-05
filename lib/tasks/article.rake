namespace :article do
  desc "clear all articles"
  task :clear => :environment do
    count = Article.count
    Article.delete_all
    puts "#{count} articles removed"
  end
end
