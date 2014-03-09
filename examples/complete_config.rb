default_formatter RRImm::ItemFormatter::Mail.new(
  from: 'rrimm@example.com',
  to: 'me@me.com'
)
pipe "msmtp -t --read-envelope-from"
#pipe "cat"

feed "http://planet.haskell.org/rss20.xml"
feed "http://www.archlinux.org/feeds/news/"
feed "http://alan.petitepomme.net/cwn/cwn.rss"

feed "xkcd" do
  uri "http://xkcd.com/rss.xml"
  category "webcomics"
end
feed 'Cartesian comics' do
  uri 'http://feeds.feedburner.com/CartesianClosedComic?format=xml'
  category "webcomics"
end
feed 'SMBC' do
  uri "http://www.smbc-comics.com/rss.php"
  category 'webcomics'
end

