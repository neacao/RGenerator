#!/usr/bin/env ruby

require 'filewatcher'
require 'json'
require 'optparse'
require './writer'

# Watcher strings.xml - Not working for now
def watching
	Filewatcher.new([$filePath]).watch do |filename, event|
		gen
	end
end

def gen(projectRoot)
	unless File.exist?(projectRoot)
		p "Not found project root: #{projectRoot}"
		return
	end

	stringFile = "#{projectRoot}/strings.json"
	unless File.file?(stringFile)
		p "Not found string file: #{stringFile}"
		return
	end

	p "Automate generate #{projectRoot} ..."

	file = File.read(stringFile)
	jsonData = JSON.parse(file)
	jsonData.each do |key, multipleValue|
		# Parse assignment
		componenets = multipleValue.split(" | ")

		# EN phase | VI phase
		writeStrings projectRoot, "en", key, componenets[0]
		writeStrings projectRoot, "vi", key, componenets[1]
		
		writeR projectRoot, key
	end
end


writer = Writer.new "ProjectRoot", "ProjectRoot", "ProjectRoot"


# ./generator.rb -p <projectRoot>



