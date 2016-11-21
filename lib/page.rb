require_relative 'fb_api'
require_relative 'posting'

module FansWatch 
  # Main class to setup a Facebook group 
  class Page 
    attr_reader :name

    def initialize(fb_api, data:) 
      @fb_api = fb_api
      @name = data['name'] 
      @id = data['id'] 
    end
    
    def feed 
      return @feed if @feed
      raw_feed = @fb_api.page_feed(@id)
      @feed = raw_feed.map do |posting| 
        FansWatch::Posting.new( 
          @fb_api,
          data: posting
        ) 
      end 
    end 

    def self.find(fb_api, id:)
      page_data = fb_api.page_info(id)
      new(fb_api, data: page_data)
    end

  end 
end
