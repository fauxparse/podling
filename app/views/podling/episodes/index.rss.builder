xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0',
        'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'xmlns:media' => 'http://search.yahoo.com/mrss/',
        'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.tag!(
      'atom:link',
      href: episodes_url(format: :rss),
      rel: 'self',
      type: 'application/rss+xml'
    )

    xml.title             Podling.podcast.name
    xml.link              Podling.podcast.url || root_url
    xml.description       Podling.podcast.description
    xml.language          Podling.podcast.language
    xml.pubDate           episodes.first.created_at.to_s(:rfc822)
    xml.lastBuildDate     episodes.first.created_at.to_s(:rfc822)
    xml.itunes :author,   Podling.podcast.author_name
    xml.itunes :keywords, Podling.podcast.keywords
    xml.itunes :explicit, Podling.podcast.explicit
    xml.itunes :image,    image_url('podcast')

    xml.itunes :owner do
      xml.itunes :name, Podling.podcast.author_name
      xml.itunes :email, Podling.podcast.author_email
    end

    xml.itunes :block, 'no'

    xml << render(partial: 'category', collection: Podling.podcast.categories)
           .gsub(/^/, '    ')

    episodes.each do |episode|
      next unless episode.audio.attached?

      xml.item do
        xml.title episode.title
        xml.description episode.description
        xml.pubDate episode.published_at.to_s(:rfc822)
        xml.enclosure(
          url: url_for(episode.audio),
          length: episode.duration,
          type: episode.audio.content_type
        )
        xml.link episode_url(episode)
        xml.guid({ isPermaLink: 'false' }, episode_url(episode))
        xml.itunes :author, Podling.podcast.author_name
        xml.itunes :subtitle, truncate(episode.description, length: 150)
        xml.itunes :summary, episode.description
        xml.itunes :explicit, 'no'
        xml.itunes :duration, episode.duration
      end
    end
  end
end
