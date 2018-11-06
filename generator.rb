#!/usr/bin/env ruby

require 'json'
require './writer'

def gen(projectRootPath, languageKeysSupporting)
	unless projectRootPath and File.file?("#{projectRootPath}/strings.json")
		usage
		return
	end

	p "Automate generate #{projectRootPath} ..."

	file = File.read("#{projectRootPath}/strings.json")
	jsonData = JSON.parse(file)

	# An array of title keys to write into R.* files
	titles = []

	# An array of language keys supported ([en, vi])
	languageKeys = languageKeysSupporting.split(",")

	# A dictionary of diction with heirarchy: { "en": { "title1": "content1", "title2": "content2" }, {} }
	contectDict = {}

	# Assign data to memory to write files
	jsonData.each do |title, value| # Multiple language have to split by "|"
		titles << title
		components = value.split("|")
		languageKeys.each_with_index do |lKey, idx|
			# Initial if needed
			unless contectDict[lKey]
				contectDict[lKey] = {}
			end

			contectDict[lKey][title] = components[idx]
		end
	end

	writer = Writer.new(projectRootPath, projectRootPath, projectRootPath)
	writer.writeR(titles)
	writer.writeLocalizeString(contectDict)

	p "Generation is done !!!"
end

def usage 
	p "Usage: ./generator.rb <projectPath> <languageKeysSupporting - split by ,> \
(ensure that these files is exist in same location: R.h, R.m, strings.json, *.lproj)"
	p "Example: ./generator ProjectRoot en,vi"
end


gen(ARGV[0], ARGV[1])




