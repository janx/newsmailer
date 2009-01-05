class NewsSender < ActionMailer::Base

  def news(article, user)
    recipients user.email
    from "#{article.feed.name} <newsmailer@aiur.planet>"
    subject article.title
    content_type article.content_type

    body :article => article
  end
end
