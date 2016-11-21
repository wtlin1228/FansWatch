# frozen_string_literal: true 
require_relative 'spec_helper.rb'

describe 'FansWatch specifications' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<ACCESS_TOKEN>'){CREDENTIALS[:access_token]}
    c.filter_sensitive_data('<ACCESS_TOKEN_ESCAPED') do
      URI.escape(CREDENTIALS[:access_token])
    end
    c.filter_sensitive_data('<CLIENT_ID>'){CREDENTIALS[:client_id]}
    c.filter_sensitive_data('<CLIENT_SECRET>'){CREDENTIALS[:client_secret]}
  end

  before do 
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes

    @fb_api = FansWatch::FbApi.new(
      client_id: CREDENTIALS[:client_id],
      client_secret: CREDENTIALS[:client_secret]
    )

    # @posting_with_msg_id = FB_RESULT['posting']['id']
  end

  after do
    VCR.eject_cassette
  end

  it 'should be able to get a new access token' do 
    fb_api = FansWatch::FbApi.new( 
      client_id: ENV['FB_CLIENT_ID'], 
      client_secret: ENV['FB_CLIENT_SECRET'] 
      )

    fb_api.access_token.length.must_be :>, 0 
  end


  it 'should be able to open a Facebook Page' do
    page = FansWatch::Page.find(
      @fb_api,
      id: ENV['FB_PAGE_ID']
    )

    page.name.length.must_be :>, 0
  end

  it 'should get the lastest feed from an page' do
    page = FansWatch::Page.find(
      @fb_api,
      id: ENV['FB_PAGE_ID']
    )

    feed = page.feed
    feed.count.must_be :>, 1
  end

  it 'should get the information about postings on the feed' do
    page = FansWatch::Page.find(
      @fb_api,
      id: ENV['FB_PAGE_ID']
    )

    posting = page.feed.first
    posting.message.length.must_be :>, 0 
  end


  it 'should find all parts of a full posting' do 
    posting = FB_RESULT[:feed]
    post = posting.first
    post_id = post['id'] 
    attachment = FB_RESULT[:attachement].first 

    retrieved = FansWatch::Posting.find(@fb_api, id: post_id.to_s)

    retrieved.id.must_equal post_id 
    retrieved.created_time.must_equal post['created_time'] 
    retrieved.message.must_equal post['message'] 
    retrieved.attachment.wont_be_nil 
    retrieved.attachment.description.must_equal attachment[1][0]['description']

  end 

end
