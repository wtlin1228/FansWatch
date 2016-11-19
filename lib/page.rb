require_relative 'fb_api'
require_relative 'posting'

module FansWatch 
  # Main class to setup a Facebook group 
  class Page 
    attr_reader :access_token, :name

    def initialize(fb_api, page_id:) 
      @fb_api = fb_api
      page = @fb_api.page_info(page_id)
      @name = page['name'] 
      @id = page['id'] 
    end
    
    def feed 
      return @feed if @feed
      raw_feed = @fb_api.page_feed(@id)
      @feed = raw_feed.map do |p| 
        FansWatch::Posting.new( 
          @fb_api,
          id: p['id'], 
          message: p['message'], 
          created_time: p['created_time'] 
        ) 
      end 
    end 
  end 
end
