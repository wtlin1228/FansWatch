# frozen_string_literal: true 
require_relative 'spec_helper.rb'

describe 'FansWatch specifications' do
  before do 
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
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

    describe 'Retrieving Page Feed' do
      it '(HAPPY) should get the lastest feed from page with proper ID' do
        page = FansWatch::Page.find(id: ENV['FB_PAGE_ID'])         
        
        feed = page.feed
        feed.count.must_be :>, 1
      end

      it '(HAPPY) should get the postings on the feed with proper ID' do
        page = FansWatch::Page.find(id: ENV['FB_PAGE_ID'])         
        
        page.feed.postings.each do |posting|
          posting.id.wont_be_nil
          posting.created_time.wont_be_nil
        end
      end 
    end         
  end 

  describe 'Finding Posting Information' do
    it '(HAPPY) should find all parts of a full posting' do
      posting = FB_RESULT[:feed].first
      attachment = FB_RESULT[:posting][:attached] 
      attachment_description = attachment[:description]
      attachment_url = attachment[:url]
      retrieved = FansWatch::Posting.find(id: posting['id'])
      
      retrieved.id.must_equal posting['id']
      retrieved.created_time.must_equal posting['created_time']
      retrieved.message.must_equal posting['message']
      retrieved.attachment.wont_be_nil
      retrieved.attachment.description.must_equal attachment_description

      # FB will change the url
      # retrieved.attachment.url.must_equal attachment_url
    end
  end        

  describe 'Get page id by URL' do
    it '(HAPPY) should find page id by correct fb page URL' do
      id = FansWatch::FbApi.page_id(HAPPY_PAGE_URL)
      
      id.wont_be_nil
    end
  end

end
