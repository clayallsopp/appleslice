require 'rubygems'
require 'bundler'
Bundler.require(:default, :spec)

require 'erb'

module Helpers
  def project_root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def specs_root
    File.join(project_root, 'spec')
  end

  class Context
    def get_binding
      binding()
    end
  end

  def email_data(file_name, erb_data = {})
    file_name << ".html.erb" unless file_name.end_with?(".html.erb")
    template = IO.read(File.join(specs_root, 'data', file_name))

    context = Context.new
    erb_data.each do |k, v|
      context.instance_variable_set("@#{k}", v)
    end
    renderer = ERB.new(template)
    renderer.result(context.get_binding)
  end
end

RSpec.configure do |c|
  c.include Helpers
end