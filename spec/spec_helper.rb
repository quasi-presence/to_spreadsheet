ENV["RAKE_ENV"] ||= 'test'
require 'rspec/autorun'
$: << File.expand_path('../lib', __FILE__)
require 'to_spreadsheet'
require 'haml'


module TestRendering
  def build_spreadsheet(src = {})
    haml = if src[:haml]
             src[:haml]
           elsif src[:file]
             File.read(File.expand_path "support/#{src[:file]}", File.dirname(__FILE__))
           end
    ToSpreadsheet::Context.with_context ToSpreadsheet::Context.global.merge(ToSpreadsheet::Context.new) do |context|
      html = Haml::Engine.new(haml).render(self)
      ToSpreadsheet::Renderer.to_package(html, context)
    end
  end
end


require 'to_spreadsheet/rails/view_helpers'
RSpec.configure do |config|
  include TestRendering
  include ::ToSpreadsheet::Rails::ViewHelpers
end