#!/usr/bin/env ruby

class Writer

	def initialize(projectRoot, rFilePath, localizeFilePath)
		@projectRoot = projectRoot
		@rFilePath = rFilePath
		@localizeFilePath = localizeFilePath
	end

	def writeR(key)
		unless @rFilePath
			p "Not found R file location with @rFilePath"
			return
		end

		headerPath 		= "#{@rFilePath}/R.h"
		implementPath 	= "#{@rFilePath}/R.m"
		unless File.file?(headerPath) or File.file?(implementPath)
			p "Not found hedaer: #{headerPath} or implement: #{implementPath}"
			return
		end
		# -----

		# Build string
		propertyH = "@property (class, nonatomic, readonly) NSString* <PROPERTY_KEY>;\n".gsub! '<PROPERTY_KEY>', key
		propertyH += "\n\/\/ <REPLACE>"

		propertyM = "+ (NSString *)<PROPERTY_KEY> {\n\treturn LOCALIZE_STRING(@\"<PROPERTY_NAME>\");\n}\n".gsub! '<PROPERTY_KEY>', key
		propertyM = propertyM.gsub! '<PROPERTY_NAME>', key
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

	def writeLocalizeString(lanugage, key, value)
		unless @localizeFilePath
			p "Not found l@ocalizeFilePath"
			return
		end

		filePath = "#{@localizeFilePath}/#{lanugage}.lproj/Localize.strings"
		unless File.file?(filePath)
			p "Not found Localize.strings in filePath #{filePath}"
			return
		end

		open(filePath, 'a') { |f| f << "\"#{key}\" = \"#{value}\";\n" }
	end

end
