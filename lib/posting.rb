require 'http'

module FansWatch 
  # Single posting on group's feed 
  class Posting 
    attr_reader :message, :updated_at, :id, :attachment
    
    def initialize(access_token, id, message, updated_at) 
      @id = id 
      @message = message 
      @updated_at = updated_at 
      @access_token = access_token 
    end

    def attachment 
      return @attachment if @attachment
    
      attachments_response = 
        HTTP.get("https://graph.facebook.com/v2.8/#{@id}/attachments", 
                 params: { access_token: @access_token }) 
      attachments = JSON.load(attachments_response.to_s) 
      attached_data = attachments['data'].first 
      @attachment = { description: attached_data['description'], 
                      url: attached_data['url'] } 
    end 
  end 
end
