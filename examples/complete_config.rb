default_formatter RRImm::ItemFormatter::Mail.new(
  from: 'rrimm@example.com',
  to: 'me@me.com'
)
pipe "msmtp -t --read-envelope-from"

# most simple declaration : feed [uri]
feed "http://www.archlinux.org/feeds/news/"

# full declaration feed [name] do [block] end
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

# namespace by category (and soon with all attributes)
category 'languages' do 
  feed 'ocaml' do
    uri 'http://alan.petitepomme.net/cwn/cwn.rss'
  end
  feed "http://planet.haskell.org/rss20.xml"
end
