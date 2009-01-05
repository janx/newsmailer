namespace :crawler do
  desc "run crawler for all feeds"
  task :run => :environment do
    Feed.all.each do |feed|
      puts "Fetching #{feed.name} ..."
      begin
        result = FeedParser.parse feed.url
        modified_at = Time.utc(*result.modified[0,8])
        next if feed.modified_at && feed.modified_at >= modified_at

        for item in result.items
          content = if item.summary_detail
                      # rss 2.0
                      item.summary_detail.value
                    elsif item.content[0]
                      # atom
                      item.content[0].value
                    end

          a = Article.find_by_url(item.link)
          if a.nil?
            feed.articles.build :title => item.title, :content => content, :url => item.link, :modified_at => item.updated_time
          elsif a.modified_at < item.updated_time
            a.update_attributes :title => item.title, :content => content, :modified_at => item.updated_time
          end
        end
        # update feed modify time and save
        feed.modified_at = modified_at
        feed.name = result.channel.title
        feed.save
      rescue RuntimeError, Exception => e
        puts e
        puts e.backtrace
        puts "Error: can't fetch feed #{feed.url}"
      end
    end
  end
end
