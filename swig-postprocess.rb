AUTOUNLINK = [ "COsdItem", "COsdMenu", "CMenuText" ]

################################################################################

#
# Add auto unlink code to SWIG director destructors like:
#
# SwigDirector_<class>::~SwigDirector_<class>() {
#    SWIG_RubyUnlinkObjects(this);
#    SWIG_RubyRemoveTracking(this);
# }
#
# With this code, when a C++ instance is delete, it will automatically remove
# itself from the list of tracked objects and unlink itself from the Ruby object
# it is used by. This means, that any call to a method of the C++ class from the
# Ruby object will now throw an ObjectPreviouslyDeleted exception.
#
def add_auto_unlink_code
  for klass in AUTOUNLINK
    @swig_code.gsub!(/(SwigDirector_#{klass}::~SwigDirector_#{klass}\(\) \{\n)(\})/m,
      "\\1  SWIG_RubyUnlinkObjects(this);\n  SWIG_RubyRemoveTracking(this);\n\\2")
  end
end

def improve_overloaded_error
  @swig_code.gsub!(/("%s )(for overloaded.*msg,)( method, prototypes)/m,
    '\1(%d) \2 argc-1,\3')
end

## main ##

@swig_code = IO.read(ARGV[0])

add_auto_unlink_code if ! AUTOUNLINK.empty?
improve_overloaded_error

File.new(ARGV[1], "w").write(@swig_code)
