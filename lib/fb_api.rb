require 'yaml'
require 'http'

credentials = YAML.load(File.read('../config/credentials.yml'))
fb_response = {}
results = {}

# Initialize API connection by getting access_token 
#  require client_id and client_secret 
access_token_response = 
	HTTP.get('https://graph.facebook.com/v2.8/oauth/access_token',
						params: { client_id: credentials[:client_id],
											client_secret: credentials[:client_secret],
											grant_type: 'client_credentials' })
fb_response[:access_token] = access_token_response 
access_token = JSON.load(access_token_response.body.to_s)['access_token'] 
results[:access_token] = access_token


# Find desired fan page:
#  requires page_id: use 3rd party site
page_id = '159425621565'
page_response = HTTP.get("https://graph.facebook.com/v2.8/#{page_id}",
													params: { access_token: access_token})
fb_response[:page] = page_response
page = JSON.load(page_response.to_s)
results[:page] = page

# Get feed from group's page 
#  requires group_id (see above), access token 
feed_response = 
	HTTP.get("https://graph.facebook.com/v2.8/#{page_id}/feed",
					 params: { access_token: access_token }) 
fb_response[:feed] = feed_response 
feed = JSON.load(feed_response.to_s)['data'] 
results[:feed] = feed

# Get particular posting from feed (minimum useful information) 
#  requires: posting_num, feed (array) 
posting_num = 0 
posting_data = feed[posting_num] 
attachments_response = 
	HTTP.get("https://graph.facebook.com/v2.8/#{posting_data['id']}/attachments", 
						params: { access_token: access_token }) 
fb_response[:attachments] = attachments_response 
attachment = JSON.load(attachments_response.to_s) 
results[:attachement] = attachment
attached_data = attachment['data'].first
attached_info = { description: attached_data['description'], 
									url: attached_data['url'] } 
posting = { body: posting_data['message'], 
						attached: attached_info } 
results[:posting] = posting

File.write('../spec/fixtures/fb_response.yml', fb_response.to_yaml)
File.write('../spec/fixtures/results.yml', results.to_yaml)

