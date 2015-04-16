// Generated Ruboto subclass with method base "none"

package net.iqeo.mywebview;

import org.ruboto.JRubyAdapter;
import org.ruboto.Log;
import org.ruboto.Script;
import org.ruboto.ScriptInfo;
import org.ruboto.ScriptLoader;

public class JSIJavaCustom extends java.lang.Object implements org.ruboto.RubotoComponent {

  public JSIJavaCustom() {
    super();
  }

  private final ScriptInfo scriptInfo = new ScriptInfo();
  public ScriptInfo getScriptInfo() {
      return scriptInfo;
  }

  /****************************************************************************************
   *
   *  Generated Methods
   */

  public java.lang.String ok() {
    if (ScriptLoader.isCalledFromJRuby()) return "oops! - ScriptLoader.isCalledFromJRuby()";
    if (!JRubyAdapter.isInitialized()) {
      Log.i("Method called before JRuby runtime was initialized: JSIJavaCustom#ok");
      return "oops! - !JRubyAdapter.isInitialized()"; 
    }
    String rubyClassName = scriptInfo.getRubyClassName();
    if (rubyClassName == null) return "oops! - rubyClassName == null";
    return (java.lang.String) JRubyAdapter.runRubyMethod(java.lang.String.class, scriptInfo.getRubyInstance(), "ok");
  }

  public java.lang.String ok_java() {
    return "ok_java";
  }

  {
    scriptInfo.setRubyClassName(getClass().getSimpleName());
    ScriptLoader.loadScript(this);
  }

}
