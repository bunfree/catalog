# -*- coding: utf-8 -*-

require 'sequel'

Sequel.sqlite('16th_catalog.sqlite')

require_relative 'catalog'

Catalog.each do |c|
    c.exhibit_ruby = 'ヨビブース' if c.exhibit_ruby.nil?
    c.exhibit_name = '予備ブース' if c.exhibit_name.nil?
    c.website = c.website.gsub(/\s+/, '') unless c.website.nil?
    c.twitter = c.twitter.gsub(/\s+/, '') unless c.twitter.nil?
    c.members = c.members.gsub(/\s+/, '') unless c.members.nil?

    circle =  if c.website.nil? || c.website.empty?
                "#{c.exhibit_name}（#{c.exhibit_ruby}）"
              else
                "[[#{c.exhibit_name}（#{c.exhibit_ruby}）|#{c.website}]]"
              end
    twitter = if c.twitter.nil? || c.twitter.empty?
                  '-'
              else
                  "[[#{c.twitter}|#{c.twitter.sub(/^@/, 'http://twitter.com/')}]]"
              end
    publicity = c.publicity.gsub("\r\n", "{{br}}") unless c.publicity.nil?
    members = if c.members.nil? || c.members.empty?
                  '-'
              else
                  c.members
              end

    table = <<EOF
||^^^^^'''#{c.booth}'''
||'''#{circle}'''
||#{twitter}
||#{c.category1} - #{c.category2}
||#{members}
||>>>#{publicity}
EOF

    ex = <<EOF
■汎例
||^^^^'''ブース番号'''
||'''サークル名（サークル名フリガナ）URL'''
||twitter
||大カテゴリ - 小カテゴリ
||メンバー
||>>>紹介文
{{br}}
{{br}}
EOF

    categ = c.booth[/^./]
    title = "第十六回サークル一覧（#{categ}）"
    file = './hiki/' + categ + '.txt'
    if File.exist?(file) then
    	File.open(file, "a") do |f|
    		f.puts table
    	end
    else
    	File.open(file, "a") do |f|
    		f.puts title
    		f.puts ex
    		f.puts table
    	end
    end
end
