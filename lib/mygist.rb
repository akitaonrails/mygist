$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'mechanize'
module Mygist
  class GistApi
    class NotLoggedIn < StandardError; end

    def initialize(username = nil, password = nil)
      @username = username
      @password = password    
      @login_page = "https://gist.github.com/login?return_to=gist"
      @logout_page = "http://gist.github.com/logout"
      @session_page = "https://gist.github.com/session"
      @post_page = "http://gist.github.com"
      @list_page = "http://gist.github.com/gists"
      @mine_page = "http://gist.github.com/mine"
      @agent = WWW::Mechanize.new
      @is_logged = false
    end

    def config!(config_file = "~/.gist")
      config_file = File.expand_path(config_file) if config_file =~ /~/
      cfg = YAML::load(File.read(config_file))
      @username = cfg["username"]
      @password = cfg["password"]
      @login_page ||= cfg["login_page"]
      @logout_page ||= cfg["logout_page"]
      @session_page ||= cfg["session_page"]
      @post_page ||= cfg["post_page"]
      @list_page ||= cfg["list_page"]
      @mine_page ||= cfg["mine_page"]
    end

    def login!
      page = @agent.get(@login_page)
      login_form = page.forms.first
      login_form.login = @username
      login_form.password = @password
      @login_page = @agent.submit(login_form)
      @is_logged = (@login_page.uri.to_s != @session_page)
    end

    def logout!
      @agent.get(@logout_page)
      nil
    end

    def create(snippet, file_name = nil, type = nil)
      raise NotLoggedIn unless @is_logged
      page = @agent.get(@post_page)
      gist_form = page.forms.first
      gist_form.field("file_ext[gistfile1]").value = type if type
      gist_form.field("file_name[gistfile1]").value = file_name if file_name
      gist_form.field("file_contents[gistfile1]").value = snippet if snippet
      gist_page = @agent.submit(gist_form)
      return $1 if gist_page.uri.to_s =~ /\/(\d+)$/
    end

    def list
      page = @agent.get(@is_logged ? @mine_page : @list_page)
      page.links.select { |l| l.text =~ /^gist/ }.map { |l| l.uri.to_s.gsub("\/", "") }
    end

    def show(gist_id, format = ".txt")
      case format
      when ".js"
        "<script src='#{@post_page}/#{gist_id}.js'></script>"
      else
        page = @agent.get("#{@post_page}/#{gist_id}.txt")
        page.content
      end
    end

    def delete!(gist_id)
      raise NotLoggedIn unless @is_logged
      @agent.get("#{@post_page}/delete/#{gist_id}")
      nil
    end

    def update!(gist_id, snippet, file_name = nil, type = nil)
      page = @agent.get("#{@list_page}/#{gist_id}/edit")
      update_form = page.forms.first

      file_content_name   = page.search("//textarea[@class='file-contents']").first.attributes['name']
      file_extension_name = page.search("//div[@class='gist-lang']").first.search("//select").first.attributes['name']
      file_name_name      = page.search("//input[@class='gist-name-textbox']").first.attributes['name']

      update_form.field(file_content_name).value = snippet

      unless file_name.nil?
        update_form.field(file_name_name).value = file_name
      else
        unless type.nil?
          update_form.field(file_extension_name).value = type
          update_form.field(file_name_name).value = ''
        end
      end

      @agent.submit(update_form)
      nil
    end
  end
end
