#
# vdr-scripting - A plugin for the Linux Video Disk Recorder
# Copyright (c) 2009 Tobias Grimm <vdr@e-tobi.net>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#
#

require 'rubygems'
require 'simple-rss'
require 'open-uri'

class HelloWorld
  def main_menu_entries
    [
      ["Open RSS Feed", :openRssFeed]
    ]
  end

  def invoke_menu_item(tag)
    case tag
      when :openRssFeed
        rss = SimpleRSS.parse open('http://rss.golem.de/rss.php?feed=RSS2.0')
        menu = Vdr::Osd::Menu.new("RSS Feed")
        for item in rss.items
          rssItem = Vdr::Osd::Item.new(item.title)
          rssItem.context = item
          rssItem.on_select do |i|
            menu.open_sub_menu(Vdr::Osd::TextView.new(i.context.title, html_to_text(i.context.description)))
          end
          menu.add_item(rssItem)
        end
        return menu
    end
  end

  def html_to_text(html)
    text = html
    text.gsub!(/&amp;/, "&")
    text.gsub!(/&lt;/, "<")
    text.gsub!(/&gt;/, ">")
    text.gsub!(/&#(\d)+;/) {|m| $1.to_i.chr}
    text.gsub!(/&amp;/, "&")
    text.gsub!(/&lt;/, "<")
    text.gsub!(/&gt;/, ">")
    text.gsub!(/<br\/>/, "")
    text.gsub!(/<\/p>\n/, "\n")
    text.gsub!(/<\/p>/, "\n")
    text.gsub!(/<[^>]*>/, '')
    return text
  end
end

Vdr::PLUGINS << HelloWorld.new
