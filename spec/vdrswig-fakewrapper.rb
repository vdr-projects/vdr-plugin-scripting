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
  module Swig

    OsUnknown = :OsUnknown
    OsContinue = :OsContinue
    OsBack = :OsBack
    OsEnd = :OsEnd

    KOk = 1
    KRed = 2
    KGreen = 3
    KBlue = 4
    KYellow = 5
    
    class COsdMenu
      attr_reader :cosdmenu_ctor_arguments, :current, :COsdMenu_help_texts, :COsdMenu_cleared

      def initialize(*args)
        @cosdmenu_ctor_arguments = args 
      end

      def set_title(title)
      end

      def add(item)
      end
      
      def process_key(key)
        return OsUnknown
      end
      
      def fake_process_key(key)
        return process_key(key)
      end

      def simulate_select(index)
        @current = index
        process_key(Vdr::Swig::KOk)
      end
 
      def set_help(red, green, yellow, blue)
        @COsdMenu_help_texts = [red, green, yellow, blue]
      end
      
      def clear
        @COsdMenu_cleared = true
      end
    end

    class COsdItem
      attr_reader :cosditem_ctor_arguments
      def initialize(*args)
        @cosditem_ctor_arguments = args 
      end

      def process_key(key)
      end
    end

    class PluginManager
    end
    
    class COsdMessage
    end
    
    class CMenuText
      attr_reader :CMenuText_title, :CMenuText_text
      
      def initialize(title, text)
        @CMenuText_title = title
        @CMenuText_text = text
      end
    end
  end
end
