module FansWatch 
# Attached URL to Posting 
  class Attachment 
	  attr_reader :description, :url 

	  def initialize(data) 
      return unless data 
	  	@description = data['description'] 
	  	@url = data['url'] 
	  end 

	 end 
end 