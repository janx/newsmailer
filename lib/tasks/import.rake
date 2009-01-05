namespace :import do
  desc "import feeds from plain url list (newsbeuter url list), the file should be located at RAILS_ROOT/urls"
  task :list => :environment do
    oldcount = Feed.count
    IO.readlines(File.join RAILS_ROOT, '/urls').each do |l|
      begin
        url = l.scan(/[^ ]+/)[0]
        Feed.create! :name => url, :url => url
      rescue
        puts "Failed to create feed: #{url}"
      end
    end
    puts "#{Feed.count - oldcount} feeds added."
  end
end
