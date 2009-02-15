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

module Vdr
  module Osd
    #
    # An #Item represents an entry in an OSD #Menu.
    # Each item has a #text that will be shown on the menu and a
    # #context which can be used to store any kind of object
    # associated with this menu item.
    #      
    # == Example
    #
    #     new_menu = Menu.new('A simple menu') do |menu|
    #       menu.add_item(Item.new('First Item').on_select { puts 'Item 1 selected' })
    #       new_item = Item.new('Second Item') do |item|
    #         item.context = { :first_name => 'James Tiberius', :last_name => 'Kirk' }
    #         item.on_select do |selected_item|
    #           name = selected_item.context
    #           puts "Selected #{name[:last_name]}, #{name[:first_name]}"
    #         end
    #       end
    #       menu.add_item(new_item)
    #    end
    #
    class Item < Vdr::Swig::COsdItem

      # The text of the item which will be shown on its parent #Menu
      attr_reader :text

      # A free assignable context associated with an #Item
      attr_accessor :context

      #
      # Creates a new item. If _text_ is given, it will become the text displayed on the
      # parent menu for this item.
      #
      #     Item.new('my item')                     #=> Creates a new item shown with 'my item'
      #     Item.new {|i| i.title = 'another item'} #=> Creates a new item and sets its title to 'another item'
      #
      def initialize(text = nil) # :yields: item
        @text = text
        super(text)
        yield self if block_given?
      end

      # Change the item text
      def text=(text)
        @text = text
        set_text(text)
      end

      # The block assigned to on_select will be executed, when
      # the item is selected from the menu
      def on_select(&block) # :yields: item
        @select = block
      end

      def process_key(key) # :nodoc:
        state = super(key)
        if key == Vdr::Swig::KOk
          if @select
            @select.call(self)
          end
          return Vdr::Swig::OsUnknown
        end
        return state
      end
    end
  end
end
