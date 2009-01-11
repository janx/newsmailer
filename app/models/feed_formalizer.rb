class FeedFormalizer

  Entry = Struct.new(:title, :modified_at, :url, :content_type, :content)

  # pass in rfeedparser's feed object
  def initialize(feed)
    raise "Feed cannot be nil" unless feed
    @feed = feed
  end

  def timestamp
    @feed.feed.updated_parsed || @feed.feed.date_parsed || @feed.updated
  end

  def status
    @feed.status
  end

  def title
    @feed.feed.title
  end

  def description
    @feed.feed.description
  end

  def raw
    @feed
  end

  def format
    @feed.version
  end

  def entries
    @entries = []
    for entry in @feed.entries
      content = content_type = nil
      if entry.content && entry.content.first
        content = entry.content.first.value
        content_type = entry.content.first.type
      elsif entry.summary_detail
        content = entry.summary_detail.value
        content_type = entry.summary_detail.type
      end
      @entries << Entry.new(entry.title, entry.updated_time, entry.link, content_type, content)
    end
    @entries
  end

end
