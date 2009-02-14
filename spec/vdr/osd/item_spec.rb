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
require 'vdr/osd/item'

describe Vdr::Osd::Item do
  before(:each) do
    @item = Vdr::Osd::Item.new('text') 
  end
  
  it 'should set the item text in the ctor' do
    @item.text.should == 'text'
    @item.cosditem_ctor_arguments[0].should == 'text'
  end

  it 'should have an assignable context' do
    @item.context = :context
    @item.context.should == :context
  end
  
  describe 'when the Ok key is pressed on the item' do
    it 'should trigger the select event' do
      item_was_selected = false;
      @item.on_select do |i|
        item_was_selected = true
        i.should == @item
      end

      @item.process_key(Vdr::Swig::KOk)
    
      item_was_selected.should == true
    end
    
    it 'should return osUnknown' do
      @item.process_key(Vdr::Swig::KOk).should == Vdr::Swig::OsUnknown
    end
  end
  
end
