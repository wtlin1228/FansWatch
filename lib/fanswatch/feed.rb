# frozen_string_literal: true
require_relative 'fb_api'
require_relative 'posting'

module FansWatch
  # Page feeds, with data and paging information
  class Feed
    attr_reader :postings

    def initialize(feed_data:)
      raw_feed = FansWatch::FbApi.page_feed(feed_data)
      @postings = raw_feed.map do |post_data|
        FansWatch::Posting.new(data: post_data)
      end

    end

    def count
      @postings.count
    end
  end
end
