require 'http' 
require_relative 'posting'

module FansWatch 
  # Main class to setup a Facebook group 
  class Page 
    attr_reader :access_token, :name

    def initialize(client_id:, client_secret:, page_id:) 
      # Initialize API connection by getting access_token 
      #  require client_id and client_secret 
      access_token_response = 
        HTTP.get('https://graph.facebook.com/oauth/access_token', 
                  params: { client_id: client_id, 
                            client_secret: client_secret, 
                            grant_type: 'client_credentials' }) 
      @access_token = access_token_response.body.to_s.split('=').last
      page_response = 
        HTTP.get("https://graph.facebook.com/v2.8/#{page_id}", 
                  params: { access_token: @access_token }) 
      page = JSON.load(page_response.to_s) 
      @name = page['name'] 
      @id = page['id'] 
    end
    
    def feed 
      return @feed if @feed
    
      feed_response = 
        HTTP.get("https://graph.facebook.com/v2.8/#{@id}/feed", 
                  params: { access_token: @access_token }) 
      raw_feed = JSON.load(feed_response.to_s)['data'] 
      @feed = raw_feed.map do |p| 
        FansWatch::Posting.new( 
          @access_token, p['id'], p['message'], p['updated_time'] ) 
      end 
    end 
  end 
end
