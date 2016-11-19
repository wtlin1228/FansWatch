require_relative 'fb_api'

module FansWatch 
  # Single posting on group's feed 
  class Posting 
    attr_reader :message, :created_time, :id, :attachment
    
    def initialize(fb_api, id:, message:, created_time:) 
      @fb_api = fb_api
      @id = id 
      @message = message 
      @created_time = created_time  
    end

    def attachment 
      return @attachment if @attachment
    
      attached_data = @fb_api.posting_attachments(@id) 
      @attachment = { 
        description: attached_data['description'], 
        url: attached_data['url'] 
      } 
    end 
  end 
end
