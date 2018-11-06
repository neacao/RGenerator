#!/usr/bin/env ruby

class Writer

	def initialize(projectRoot, rFilePath, localizeFilePath)
		@projectRoot = projectRoot
		@rFilePath = rFilePath
		@localizeFilePath = localizeFilePath
	end

	def writeR(keys)
		headerPath 		= "#{@rFilePath}/R.h"
		implementPath 	= "#{@rFilePath}/R.m"

		# Build string
		propertyH = ""
		propertyM = ""

		keys.each do |key|
			propertyH += appendHeaderContent(key)
			propertyM += appendImplementationContent(key)
		end
		
		propertyH += "\n\/\/ <REPLACE>"
		propertyM += "\n\/\/ <REPLACE>"

		# Header replacement
		file = File.read(headerPath)
		newContents = file.gsub /\/\/ <REPLACE>/, propertyH
		open(headerPath, 'w') { |file| file.puts newContents }

		# Implementation replacement
		file = File.read(implementPath)
		newContents = file.gsub /\/\/ <REPLACE>/, propertyM
		open(implementPath, 'w') { |file| file.puts newContents }
	end


	# contentArray = { "en": {"title1": "content1", "title2": "content2"}, {"vi": {"chủ đề 1": "nội dung 1"}} }
	def writeLocalizeString(contentDict)
		contentDict.each do |languageKey, dict|
			contentStr = ""
			dict.each do |title, content|
				contentStr += "\"#{title}\" = \"#{content}\";\n"
			end
			open("#{@localizeFilePath}/#{languageKey}.lproj/Localize.strings", 'a') { |f| f << contentStr }
		end
	end


	private
		def appendHeaderContent(key)
			propertyH = "@property (class, nonatomic, readonly) NSString* #{key};\n"
			propertyH
		end

		def appendImplementationContent(key)
			propertyM = "+ (NSString *)#{key} {\n\treturn LOCALIZE_STRING(@\"#{key}\");\n}\n"
			propertyM
		end

end
