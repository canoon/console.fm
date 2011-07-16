#!/usr/bin/ruby

require 'nokogiri'
require 'net/http'
require 'net/https'
require 'escape'

http = Net::HTTP.new('console.fm')

genre = ARGV[0]
sessionid = '_consolefm_session=BAh7CEkiD3Nlc3Npb25faWQGOgZFRkkiJTNlMmYwNGVhNzkyMTU2MDUwMzdjZWQ5YWU5MTdkZjAwBjsAVEkiCm9hdXRoBjsARnsGSSIMdHdpdHRlcgY7AEZ7BkkiF2NhbGxiYWNrX2NvbmZpcm1lZAY7AEZUSSIQdHdpdHRlcl91aWQGOwBGewc6CnZhbHVlSSIOMzE4ODA5NjAzBjsAVDoMZXhwaXJlc1U6IEFjdGl2ZVN1cHBvcnQ6OlRpbWVXaXRoWm9uZVsISXU6CVRpbWUNDNobwMVChOUJOgtAX3pvbmUiCFVUQzoNbmFub19udW1pAjgBOg1uYW5vX2RlbmkGOg1zdWJtaWNybyIHMSBJIghVVEMGOwBGQBQ%3D--980a755d5e5a0cb353249446bd4bbbb386be2ab8'

`mkdir -p '#{genre}'`

resp, data = http.get('/genres/#{genre}', {"Cookie" => sessionid})

doc = Nokogiri::HTML(data)

p doc
p doc.css(".playlist")
doc.css(".playlist li a").each{|x|
	if x.content =~ /^([0-9]+)\) "([^"]*)" by (.*)$/
		num, name, author = $~.captures
		system (Escape.shell_command(["wget", x['href'], '-O',  "#{genre}/#{num} #{author} - #{name}.mp3"]))

	end
}
