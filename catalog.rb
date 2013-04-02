require 'rubygems'
require 'sequel'

class Catalog < Sequel::Model
  def booth
    "#{booth_sig}#{booth_no}"
  end
end
