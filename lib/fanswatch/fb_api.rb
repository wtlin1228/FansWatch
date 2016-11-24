require 'http'
require 'json'

module FansWatch
  # Service for all FB API calls
  class FbApi
    FB_URL = 'https://graph.facebook.com'
    API_VER = 'v2.8'
    FB_API_URL = URI.join(FB_URL, "#{API_VER}/")
    FB_TOKEN_URL = URI.join(FB_API_URL, 'oauth/access_token')

    def initialize(client_id:, client_secret:)
      access_token_response = 
      	HTTP.get(FB_TOKEN_URL,
      					 params: { client_id: client_id,
      										 client_secret: client_secret,
      										 grant_type: 'client_credentials' })
      @access_token = JSON.load(access_token_response.to_s)['access_token'] 
    end

    def self.access_token
      return @access_token if @access_token

      access_token_response =
        HTTP.get(FB_TOKEN_URL,
                 params: { client_id: config[:client_id],
                           client_secret: config[:client_secret],
                           grant_type: 'client_credentials' })
      @access_token = access_token_response.parse['access_token']
    end

    def self.config=(credentials)
      @config ? @config.update(credentials) : @config = credentials
    end

    def self.config
      return @config if @config
      @config = { client_id:     ENV['FB_CLIENT_ID'],
                  client_secret: ENV['FB_CLIENT_SECRET'] }
    end


    # Get the fans page's name and id
    #   ex: @id="159425621565",
    #       @name="Inside 硬塞的網路趨勢觀察"
    def self.page_info(page_id)
      fb_resource(page_id)
    end

    # Get the collection of fans page's postings' (message, created_time and id)
    #   ex : {
    #           "message"=> "日前金管會確認 Apple Pay、Samsung Pay 等行動支付服務將可進入台灣市場運作後，Google 所提出 Android Pay 也確認將可進入台灣市場。而從相關說法透露，Android Pay 最快將會在近期內於台灣市場推行，但具體時間依然要等 Google 說明。",
    #           "created_time"=>"2016-11-22T05:58:05+0000",
    #           "id"=>"159425621565_10153840498126566"
    #         },
    #
    #                              .
    #                              .
    #                              .
    # 
    #        {
    #           "message"=>"橘子集團發表新的揪團通訊 App：  BeanGo！ 記者會",
    #           "created_time"=>"2016-11-22T05:38:12+0000",
    #           "id"=>"159425621565_10153840469861566"
    #         }
    def self.page_feed(page_id)
      feed_response = 
      	HTTP.get(URI.join(fb_resource_url(page_id), 'feed'),
                 params: { access_token: access_token })
      JSON.load(feed_response.to_s)['data']
    end

    # Get the single posting's basic information by posting id 
    #   which we can get from page_feed
    #   ex : {
    #           "created_time"=>"2016-11-22T03:44:08+0000",
    #           "message"=>"網路中立性原則要求網路服務供應商及政府應平等處理所有網路上的資料，不差別對待或依不同用戶、內容、網站、平台、應用、接取裝置類型或通訊模式而差別收費。而這也是早逝的 RSS 共同開發者與 Reddit 創辦人 Aaron Swartz 長期以來所不斷捍衛的信念和目標。",
    #           "id"=>"159425621565_10153840361851566"
    #         }
    def self.posting(posting_id) 
      fb_resource(posting_id) 
    end

    # Get the attachment of a posting
    #   ex : {
    #           "description"=>"美國下一任總統川普正式任命兩名顧問，以幫助他完成在聯邦通信委員會監督（FCC）的過渡。這兩名顧問分別是 Jeff Eisenach 和 Mark Jamison，均是網路中立性原則的激烈反對者。",
    #           "media"=>
    #            {
    #               "image"=>
    #                {
    #                  "height"=>720,
    #                  "src"=>"https://external.xx.fbcdn.net/safe_image.php?d=AQBO6Ai9foDoVI1f&w=720&h=720&url=https%3A%2F%2Fwww.inside.com.tw%2Fwp-content%2Fuploads%2F2016%2F11%2F24343769071_d409f67726_k.jpg&cfs=1&sx=450&sy=0&sw=1365&sh=1365",
    #                  "width"=>720
    #                }
    #            },
    #           "target"=>
    #            {
    #               "url"=>"https://www.facebook.com/l.php?u=https%3A%2F%2Fwww.inside.com.tw%2F2016%2F11%2F22%2Fdonald-j-trump-net-neutrality&h=ATO8VyRbirwfQAQraYgt8e1aQEoG6oAneIqomLzhe0gGVg_0iE5TAeJhKyhjRzwuCtvKy2mDXL6iSKtwmB6ABCLbyE8&s=1&enc=AZMg3ju-UJWf_VvBESGjeaIUYH7vIVJLQaULvMxBrH0BI7tKrX3KXKyvL-oU5dMdUzANLjxddUlsQOX7Auz-sChD"
    #            },
    #            "title"=>"川普的 FCC 團隊，可能會終結網路中立性原則",
    #            "type"=>"share",
    #            "url"=>"https://www.facebook.com/l.php?u=https%3A%2F%2Fwww.inside.com.tw%2F2016%2F11%2F22%2Fdonald-j-trump-net-neutrality&h=ATO8VyRbirwfQAQraYgt8e1aQEoG6oAneIqomLzhe0gGVg_0iE5TAeJhKyhjRzwuCtvKy2mDXL6iSKtwmB6ABCLbyE8&s=1&enc=AZMg3ju-UJWf_VvBESGjeaIUYH7vIVJLQaULvMxBrH0BI7tKrX3KXKyvL-oU5dMdUzANLjxddUlsQOX7Auz-sChD"
    #         }

    def self.posting_attachments(posting_id)
      attachments_response = 
        HTTP.get(URI.join(fb_resource_url(posting_id), 'attachments'), 
                 params: { access_token: access_token })
        JSON.load(attachments_response.to_s)['data'].first
    end

    private

    def self.fb_resource_url(id) 
      URI.join(FB_API_URL, "/#{id}/") 
    end 
    
    def self.fb_resource(id)
      response = HTTP.get(
        fb_resource_url(id),
        params: {access_token: access_token })
      JSON.load(response.to_s)
    end

  end
end

