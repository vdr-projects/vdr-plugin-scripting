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
    class Menu < Vdr::Swig::COsdMenu
      attr_reader :title
      def initialize(title=nil)
        @title = title
        super(@title)
        @items = []
        yield(self) if block_given?
      end

      def title=(title)
        @title = title
        set_title(@title)
      end

      def add_item(item)
        @items << item
        add(item)
      end

      def [](index)
        return @items[index]
      end

      def open_sub_menu(menu)
        add_sub_menu(menu)
      end

      def process_key(key)
        state = super(key)
        case @close_request
        when :close
          return Vdr::Swig::OsBack
        when :close_all
          return Vdr::Swig::OsEnd
        end
        return state
      end

      def close
        @close_request = :close
      end

      def close_all
        @close_request = :close_all
      end

      def add_new_item(title)
        item = Item.new(title)
        add_item(item)
        return item
      end
    end
  end
end
