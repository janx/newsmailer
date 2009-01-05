namespace :crawler do
  desc "update all feeds"
  task :start => :environment do
    Feed.all.each do |feed|
      puts "Fetching #{feed.name} ..."
      begin
        result = FeedParser.parse feed.url
        time_ary = result.modified || result.channel.updated_parsed
        modified_at = Time.utc(*time_ary[0,8])
        next if feed.modified_at && feed.modified_at >= modified_at

        for item in result.items
          if item.summary_detail
            # rss 2.0
            content = item.summary_detail.value
            content_type = item.summary_detail.type
          elsif item.content[0]
            # atom
            content = item.content[0].value
            content_type = item.content[0].type
          end

          a = Article.find_by_url(item.link)
          attrs = {:title => item.title, :content => content, :url => item.link, :modified_at => item.updated_time, :content_type => content_type}
          if a.nil?
            feed.articles.build attrs
          elsif a.modified_at.blank? || (a.modified_at < item.updated_time)
            a.update_attributes attrs
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

  desc "delivery news to users"
  task :run => :start do
    User.all.each do |user|
      articles = Article.find_by_sql "select articles.* from articles inner join feeds on articles.feed_id = feeds.id inner join feeds_users on feeds.id = feeds_users.feed_id inner join users on feeds_users.user_id = users.id where users.id = #{user.id} and articles.updated_at > '#{user.delivered_at}'"
      articles.each {|article| article.send_to user}
    end
  end
end
