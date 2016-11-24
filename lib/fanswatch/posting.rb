# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'attachment'

module FansWatch 
  # Single posting on group's feed 
  class Posting 
    attr_reader :message, :created_time, :id, :attachment
    
    def initialize(data: nil) 
      load_data(data)
    end

    def attachment 
      return @attachment if @attachment
    
      attached_data = FbApi.posting_attachments(@id) 
    end 

    def self.find(id:)
      posting_data = FbApi.posting(id)
      new(data:posting_data)
    end

    private 

    def load_data(posting_data)
      @id = posting_data['id']
      @created_time = posting_data['created_time'] 
      @message = posting_data['message']

      attached = attachment
      @attachment = Attachment.new(attached) if attached 
    end
  end 
end
