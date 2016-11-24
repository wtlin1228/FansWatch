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
      client_id: ENV['FB_CLIENT_ID'],
      client_secret: ENV['FB_CLIENT_SECRET']
    )

    # @posting_with_msg_id = FB_RESULT['posting']['id']
  end

  after do
    VCR.eject_cassette
  end

  describe 'FbApi Credientials' do 
    it '(HAPPY) should get new access token with ENV credientials' do
      FansWatch::FbApi.access_token.length.must_be :>, 0
    end

    it '(HAPPY) should get new access_token with file credientials' do
      FansWatch::FbApi.config = { client_id: ENV['FB_CLIENT_ID'],
                                  client_secret: ENV['FB_CLIENT_SECRET'] }
      FansWatch::FbApi.access_token.length.must_be :>, 0                                
    end
  end

  describe 'Finding Page information' do
    describe 'Find a page' do
      it '(HAPPY) should be able to fine a Facebook Page with proper page ID' do
        page = FansWatch::Page.find(id: ENV['FB_PAGE_ID'])         

        page.name.length.must_be :>, 0
      end

      it '(SAD) should return nil Page ID is invalid' do
        page = FansWatch::Page.find(id: INVALID_PAGE_ID)         
        page.must_be_nil
      end
    end
  end 

end
