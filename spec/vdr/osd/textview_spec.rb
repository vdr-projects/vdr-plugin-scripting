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

require  File.expand_path(File.dirname(__FILE__) + '/../../helper')
require 'vdr/osd/textview'

describe Vdr::Osd::TextView do
  describe 'when created' do
    it 'should set title and text of the text view' do
      text_view = Vdr::Osd::TextView.new('title', 'text')
      text_view.CMenuText_title.should == 'title'
      text_view.CMenuText_text.should == 'text'
    end
  end
end
