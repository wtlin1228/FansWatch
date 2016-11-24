# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FansWatch 
  # Main class to setup a Facebook group 
  class Page 
    attr_reader :name, :id, :feed

    def initialize(page_data:) 
      @name = page_data['name'] 
      @id = page_data['id']
      @feed = Feed.new(feed_data: @id)

    end

    def self.find(id:)
      page_data = FbApi.page_info(id)
      page_data.include?('error') ? nil : new(page_data: page_data)
    end

  end 
end
