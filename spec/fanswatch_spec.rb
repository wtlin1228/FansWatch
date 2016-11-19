# frozen_string_literal: true 
require 'minitest/autorun' 
require 'minitest/rg' 
require 'yaml'

require './lib/page.rb'

CREDENTIALS = YAML.load(File.read('config/credentials.yml')) 
FB_RESPONSE = YAML.load(File.read('spec/fixtures/fb_response.yml')) 
RESULTS = YAML.load(File.read('spec/fixtures/results.yml'))

describe 'FansWatch specifications' do
  before do 
    @fb_api = FansWatch::FbApi.new(
      client_id: CREDENTIALS[:client_id],
      client_secret: CREDENTIALS[:client_secret]
    )
  end

  it 'should be able to open a Facebook Page' do
    page = FansWatch::Page.new(
      @fb_api,
      page_id: CREDENTIALS[:page_id]
    )

    page.name.length.must_be :>, 0
  end

  it 'should get the lastest feed from an page' do
    page = FansWatch::Page.new(
      @fb_api,
      page_id: CREDENTIALS[:page_id]
    )

    feed = page.feed
    feed.count.must_be :>, 10
  end

  it 'should get the information about postings on the feed' do
    page = FansWatch::Page.new(
      @fb_api,
      page_id: CREDENTIALS[:page_id]
    )

    posting = page.feed.first
    posting.message.length.must_be :>, 0 
  end

  it 'should find attachments in postings' do
    page = FansWatch::Page.new(
      @fb_api,
      page_id: CREDENTIALS[:page_id]
    )

    posting = page.feed.first
    posting.attachment[:url].length.must_be :>, 0
  end


end
