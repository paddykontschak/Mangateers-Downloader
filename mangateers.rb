#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open(ARGV[0]))
Title 	= Array.new(doc.css('head title'))
title = Title[0].content.partition(" - ")[0]
dir = title.gsub("Mangateers > ", "").gsub(" > ", "_").tr(" ", "_").tr("(","").tr(")","")
Pages 	= Array.new(doc.css('#viewer-nav a'))
print "Downloading " + title
puts `mkdir #{dir}`
total_page = Pages[1..-2].length
current = 0
Pages[1..9].each do |item|
	current = current + 1
	page = Nokogiri::HTML(open("http://mangateers.com/" + item['href']))
	element = Array.new(page.css('#viewer-page.box img'))
	img = element[0]['src']
	print "File #{current}/#{total_page}"
	puts `wget -q -c -P #{dir} #{img} -O #{dir}/0#{current}.png`
end
Pages[10..-2].each do |item|
	current = current + 1
	page = Nokogiri::HTML(open("http://mangateers.com/" + item['href']))
	element = Array.new(page.css('#viewer-page.box img'))
	img = element[0]['src']
	print "File #{current}/#{total_page}"
	puts `wget -q -c -P #{dir} #{img} -O #{dir}/#{current}.png`
end
print `zip #{dir}.zip #{dir}/`
print `rm -rf #{dir}`
puts "Done, Saved to \"#{dir}.zip\" "
