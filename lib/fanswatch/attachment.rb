module FansWatch 
# Attached URL to Posting 
  class Attachment 
	  attr_reader :description, :url, :title, :image_url 

	  def initialize(data) 
      return unless data 
	  	@description = data['description'] 
	  	@url = data['url'] 
	  	@title = data['title']
	  	@image_url = data['media']['image']['src']
	  end 

	 end 
end 