require_relative 'fb_api'
require_relative 'attachment'

module FansWatch 
  # Single posting on group's feed 
  class Posting 
    attr_reader :message, :created_time, :id
    
    def initialize(fb_api, data: nil) 
      @fb_api = fb_api
      load_data(data)
    end

    def attachment 
      return @attachment if @attachment
    
      attached_data = @fb_api.posting_attachments(@id) 
      @attachment = Attachment.new(attached_data)
    end 

    def self.find(fb_api, id:)
      posting_data = fb_api.posting(id)
      new(fb_api, data:posting_data)
    end

    private 

    def load_data(posting_data)
      @id = posting_data['id']
      # @updated_time = posting_data['updated_time'] 
      @created_time = posting_data['created_time'] 
      @message = posting_data['message'] 
      attached = posting_data['attachment'] 
      @attachment = Attachment.new(attached) if attached 
    end
  end 
end
