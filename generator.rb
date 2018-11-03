#!/usr/bin/env ruby

require "filewatcher"
require "json"

def watching
	Filewatcher.new([$filePath]).watch do |filename, event|
		gen
	end
end

def writeR(projectRoot, key)
	headerPath = "#{projectRoot}/R.h"
	implementPath = "#{projectRoot}/R.m"
	unless File.file?(headerPath) or File.file?(implementPath)
		p "Not found hedaer: #{headerPath} or implement: #{implementPath}"
		return 
	end

	# Replace sub string
	tempFormat = $propertyHFormat
	propertyH = "@property (class, nonatomic, readonly) NSString* <PROPERTY_KEY>;\n".gsub! '<PROPERTY_KEY>', key
	propertyH += "\n\/\/ <REPLACE>"

	propertyM = "+ (NSString *)<PROPERTY_KEY> {\n\treturn LOCALIZE_STRING(@\"<PROPERTY_NAME>\");\n}\n".gsub! '<PROPERTY_KEY>', key
	propertyM = propertyM.gsub! '<PROPERTY_NAME>', key
	propertyM += "\n\/\/ <REPLACE>"

	# Header
	file = File.read(headerPath)
	newContents = file.gsub /\/\/ <REPLACE>/, propertyH
	open(headerPath, 'w') { |file| file.puts newContents }

	# Implementation
	file = File.read(implementPath)
	newContents = file.gsub /\/\/ <REPLACE>/, propertyM
	open(implementPath, 'w') { |file| file.puts newContents }
end

def writeStrings(projectRoot, languageKey, key, value)
	filePath = "#{projectRoot}/#{languageKey}.lproj/Localize.strings"
	unless File.file?(filePath)
		p "Not found #{filePath}"
		return
	end

	open(filePath, 'a') { |f| f << "\"#{key}\" = \"#{value}\";\n" }
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

		# 1st = EN | 2nd = VI
		writeStrings projectRoot, "en", key, componenets[0]
		writeStrings projectRoot, "vi", key, componenets[1]
		
		writeR projectRoot, key

	end
end


puts "projectRoot: "
projectRoot = gets.chomp
gen projectRoot




