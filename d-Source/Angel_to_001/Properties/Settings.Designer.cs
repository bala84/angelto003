﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан программой.
//     Исполняемая версия:2.0.50727.1433
//
//     Изменения в этом файле могут привести к неправильной работе и будут потеряны в случае
//     повторной генерации кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Angel_to_001.Properties {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "9.0.0.0")]
    internal sealed partial class Settings : global::System.Configuration.ApplicationSettingsBase {
        
        private static Settings defaultInstance = ((Settings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new Settings())));
        
        public static Settings Default {
            get {
                return defaultInstance;
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.ConnectionString)]
        [global::System.Configuration.DefaultSettingValueAttribute("Data Source=192.168.144.244;Initial Catalog=ANGEL_TO_001_TEST4;Persist Security I" +
            "nfo=True;User ID=ANGEL_TO_001_TEST_OWNER4;Password=ANGEL_TO_001_TEST_OWNER41")]
        public string ANGEL_TO_001_ConnectionString {
            get {
                return ((string)(this["ANGEL_TO_001_ConnectionString"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.ConnectionString)]
        [global::System.Configuration.DefaultSettingValueAttribute("jdbc:jtds:sqlserver://192.168.144.244:1433/ANGEL_TO_001_TEST4;USER=ANGEL_TO_001_T" +
            "EST_AU;PASSWORD=ANGEL_TO_001_TEST_AU1")]
        public string ANGEL_TO_001_REPORTS_ConnectionString {
            get {
                return ((string)(this["ANGEL_TO_001_REPORTS_ConnectionString"]));
            }
        }
    }
}
