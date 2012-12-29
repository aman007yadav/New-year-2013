require 'sinatra'
require 'omniauth/oauth'

enable :sessions

APP_ID = "310086485758149"
APP_SECRET = "f6272476decbc3c0b10f75e1dad06f60"

use OmniAuth::Builder do  
  provider :facebook, APP_ID, APP_SECRET, { :scope => 'email, status_update, publish_stream' }
end

get '/' do
    @articles = []
    @articles << {:title => 'Introduction to Heroku', :url => 'http://docs.heroku.com/heroku'}
    @articles << {:title => 'Deploying Rack-based apps in Heroku', :url => 'http://docs.heroku.com/rack'}
    @articles << {:title => 'Learn Ruby in twenty minutes', :url => 'http://www.ruby-lang.org/en/documentation/quickstart/'}
    
    erb :index
end

get '/auth/facebook/callback' do
  session['fb_auth'] = request.env['omniauth.auth']
  session['fb_token'] = session['fb_auth']['credentials']['token']
  session['fb_error'] = nil
  redirect '/'
end

get '/auth/failure' do
  clear_session
  session['fb_error'] = 'In order to use this site you must allow us access to your Facebook data<br />'
  redirect '/'
end

get '/logout' do
  clear_session
  redirect '/'
end

def clear_session
  session['fb_auth'] = nil
  session['fb_token'] = nil
  session['fb_error'] = nil
end
