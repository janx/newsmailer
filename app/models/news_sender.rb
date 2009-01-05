class NewsSender < ActionMailer::Base

  def news(article, user)
    recipients user.email
    from "#{article.feed.name} <newsmailer@aiur.planet>"
    subject article.title

    body :article => article
  end
end
