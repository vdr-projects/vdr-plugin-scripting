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
    # The Menu class represents a basic OSD menu with a title
    # and a bunch of items.
    #
    class Menu < Vdr::Swig::COsdMenu
      # The title of the menu
      attr_reader :title

      # Creates a new menu, optionally with the given _title_
      def initialize(title=nil) # :yields: menu
        @title = title
        super(@title)
        @items = []
        @red_help = @green_help = @yellow_help = @blue_help = nil
        @keypress_event_handler = {}
        yield(self) if block_given?
      end

      # Sets the _title_ of the menu
      def title=(title)
        @title = title
        set_title(@title)
      end

      # Adds the Item _item_ to the menu
      def add_item(item)
        @items << item
        add(item)
      end

      # Item reference returning an Item by index
      def [](index)
        return @items[index]
      end

      # Opens the given _menu_ as a sub menu
      def open_sub_menu(menu)
        add_sub_menu(menu)
      end

      # Request to close the menu
      def close
        @close_request = :close
      end

      # Request to close all menus
      def close_all
        @close_request = :close_all
      end

      # Create and add a new item with the given _title_ and returns the added
      # Item
      def add_new_item(title)
        item = Item.new(title)
        add_item(item)
        return item
      end

      # Sets the help text for the red button
      def red_help=(text)
        @red_help = text
        update_help_texts
      end

      # Sets the help text for the green button
      def green_help=(text)
        @green_help = text
        update_help_texts
      end

      # Sets the help text for the yellow button
      def yellow_help=(text)
        @yellow_help = text
        update_help_texts
      end

      # Sets the help text for the blue button
      def blue_help=(text)
        @blue_help = text
        update_help_texts
      end
      
      #
      # Sets an event handler for the key press event. If _key_ is not
      # given, the event handler will be called for any key, otherwise
      # just for the specific key. In the latter case, no parameter is
      # passed to the event handler.
      # 
      #     menu.on_keypress do |key|
      #       case key
      #         when :key_red
      #           puts "Red key pressed"
      #         when :key_yellow
      #           puts "Yellow key pressed"
      #        end
      #     end
      #
      #     menu.on_keypress(:key_red) { puts 'Red key pressed' }
      #
      def on_keypress(key=:key_any, &event_handler) # :yield: key
        @keypress_event_handler[key] = event_handler
      end
      
      # Deletes all menu items
      def clear
        super
      end
      
      # Refresh the menu. This must be called, when the menu has been changed.
      def refresh
        display
      end
      
      protected

      def process_key(key) # :nodoc:
        state = super(key)
        case @close_request
        when :close
          return Vdr::Swig::OsBack
        when :close_all
          return Vdr::Swig::OsEnd
        end
        key_symbol = KEYMAP[key]
        if @keypress_event_handler[:key_any]
          @keypress_event_handler[:key_any].call(key_symbol)
        end
        if @keypress_event_handler[key_symbol]
          @keypress_event_handler[key_symbol].call
        end
        return state
      end
      
      private
      
      KEYMAP =
      {
        Vdr::Swig::KRed    => :key_red,
        Vdr::Swig::KGreen  => :key_green,
        Vdr::Swig::KYellow => :key_yellow,
        Vdr::Swig::KBlue   => :key_blue,
      }

      def update_help_texts
        set_help(@red_help, @green_help, @yellow_help, @blue_help)
      end
    end
  end
end
