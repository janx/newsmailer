class Crawler

  def start
    num = REFRESH_THREADS ? REFRESH_THREADS : 1
    num = 1 if num < 1

    sliced = slice Feed.all, num
    threads = []
    for feeds in sliced
      threads << Thread.new(feeds) { |fs| fetch fs }
    end

    threads.each {|t| t.join}
  end

  def deliver
    User.all.each do |user|
      user.news.each do |article|
        article.send_to user
      end
      user.update_attribute :delivered_at, Time.now
    end
  end

  private

  def fetch(feeds)
    feeds.each do |feed|
      puts "Fetching #{feed.name} ..."
      feed.refresh
    end
  end

  def slice(feeds, num)
    return [feeds] if num <= 1 || num >= feeds.size
    n = feeds.size/num
    sliced = []
    0.upto(num) {|i| sliced << feeds[i*n,n] }
    sliced
  end

end

