
ENV['RACK_ENV'] ||= "development"

require_relative './models/tag'
require_relative './models/link'
require_relative 'datamapper_setup'
require 'sinatra/base'


class BookmarkManager < Sinatra::Base

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/add_links'
  end

  post '/links' do
    link = Link.create(title: params[:title], url: params[:url])
    tags = params[:tag].split(',').map{|tag| Tag.first_or_create(name: tag.strip)}
    tags.each{|tag| link.tags << tag}
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

end
