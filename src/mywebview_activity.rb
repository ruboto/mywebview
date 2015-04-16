
require 'ruboto/widget'
require 'jruby/core_ext'

# java_import 'android.webkit.JavascriptInterface'

require_relative 'jsi_java_custom.rb'

ruboto_import_widget :WebView, "android.webkit"

class MywebviewActivity
  
  def on_create(bundle)
    super
    android::webkit::WebView.web_contents_debugging_enabled = true
    @wv = web_view id: 100
    @wv.settings.use_wide_view_port = true
    @wv.settings.load_with_overview_mode = true
    @wv.settings.allow_file_access = true
    @wv.settings.java_script_enabled = true
    @wv.settings.java_script_can_open_windows_automatically = true
    @wv.settings.loads_images_automatically = true
    @wv.settings.support_zoom = true
    @wv.settings.built_in_zoom_controls = true
    @wv.settings.display_zoom_controls = false
    @wv.clear_cache true
    @wv.clear_history

    @wv.add_javascript_interface java::lang::String.new("abc"), "jsi_string"

    @wv.add_javascript_interface JSIRuby.new,                   "jsi_ruby"
    @wv.add_javascript_interface JSIRubySubJava.new,            "jsi_rubysubjava"
    @wv.add_javascript_interface JSIRuby.new.to_java,           "jsi_ruby_to_java"
    @wv.add_javascript_interface JSIRubySubJava.new.to_java,    "jsi_rubysubjava_to_java"
    @wv.add_javascript_interface JSIJavaCustom.new,             "jsi_javacustom"

    # Does not work...
    # .newInstance() causes java.lang.InstantiationException: class org.jruby.RubyObject has no zero argument constructor
    #  @wv.add_javascript_interface (JSIRuby.become_java!).newInstance(), "jsi_ruby_become_java"

    # Does not work...
    # .become_java! does not work for subclasses of Java classes : https://github.com/jruby/jruby/issues/2359
    # @wv.add_javascript_interface (JSIRubySubJava.become_java!).new, "jsi_rubysubjava_become_java"
    
    @wv.load_url "file:///android_asset/html/test.html"
    self.content_view = @wv 
  end

  def on_resume
    super
    @wv.request_focus
  end

end

class JSIRuby
  # java_annotation :JavascriptInterface
  java_signature "java.lang.String ok()"
  def ok ; "ok" ; end
end

class JSIRubySubJava < java::lang::Object
  # java_annotation :JavascriptInterface
  java_signature "java.lang.String ok()"
  def ok ; "ok" ; end
end

=begin

Tried with and without java_signature

Tried java_annotation for sdk target >= 17 ...

  java_annotation :JavascriptInterface
  java_annotation JavascriptInterface
  java_annotation android.webkit.JavascriptInterface
  java_annotation android::webkit::JavascriptInterface
  java_annotation "JavascriptInterface"
  java_annotation "android.webkit.JavascriptInterface"
  java_annotation "android::webkit::JavascriptInterface"
  
=end

=begin

Javascript console result ...

jsi_string.toString()             #=> "abc"
jsi_string.length()               #=> 3
jsi_string.toUpperCase()          #=> "ABC"

jsi_ruby.toString()               #=> "#<JSIRuby:0x3fd64234>"
jsi_ruby_tojava.toString()        #=> "#<JSIRuby:0x1af07fd7>"
jsi_rubysubjava.toString()        #=> "org.jruby.proxy.java.lang.Object$Proxy0@e176b18"
jsi_rubysubjava_tojava.toString() #=> "org.jruby.proxy.java.lang.Object$Proxy0@36a420c4"

jsi_ruby.ok()                     #=> Uncaught TypeError: undefined is not a function
jsi_ruby_tojava.ok()              #=> Uncaught TypeError: undefined is not a function
jsi_rubysubjava.ok()              #=> Uncaught TypeError: undefined is not a function
jsi_rubysubjava_tojava.ok()       #=> Uncaught TypeError: undefined is not a function

jsi_javacustom.toString()         #=> "#<JSIJavaCustom:0x33a028c6>"
jsi_javacustom.ok_java()          #=> Uncaught TypeError: undefined is not a function
jsi_javacustom.ok()               #=> Uncaught TypeError: undefined is not a function

=end

