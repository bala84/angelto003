﻿using System;
using System.Xml;  
using System.Configuration;
using System.Reflection;


namespace Angel_to_001
{
    public class ConfigSettings
    {
        private ConfigSettings() { }

        public static string ReadSetting(string key)
        {
            return ConfigurationSettings.AppSettings[key];
        }

        public static void WriteSetting(string choosed_node, string key, string value , string provider_name)
        {
            string v_key_ident = "key";
            // load config document for current assembly
            XmlDocument doc = loadConfigDocument();

            // retrieve appSettings node
            XmlNode node = doc.SelectSingleNode("//" + choosed_node);

            if (choosed_node == "connectionStrings")
            {
                v_key_ident = "name";
            }

            if (node == null)
                throw new InvalidOperationException("appSettings section not found in config file.");

            try
            {
                // select the 'add' element that contains the key
                XmlElement elem = (XmlElement)node.SelectSingleNode(string.Format("//add[@" + v_key_ident + "='{0}']", key));


                node.RemoveChild(node.SelectSingleNode(string.Format("//add[@" + v_key_ident + "='{0}']", key)));

                elem = doc.CreateElement("add");
                elem.SetAttribute(v_key_ident, key);
                if (choosed_node == "connectionStrings")
                {
                    elem.SetAttribute("connectionString", value);
                }
                else
                {
                    elem.SetAttribute("value", value);
                }
                if (choosed_node == "connectionStrings")
                {
                    elem.SetAttribute("providerName", provider_name);
                }
                node.AppendChild(elem);

                doc.Save(getConfigFilePath());
            }
            catch
            {
                throw;
            }
        }

        public static void RemoveSetting(string key)
        {
            // load config document for current assembly
            XmlDocument doc = loadConfigDocument();

            // retrieve appSettings node
            XmlNode node = doc.SelectSingleNode("//appSettings");

            try
            {
                if (node == null)
                    throw new InvalidOperationException("appSettings section not found in config file.");
                else
                {
                    // remove 'add' element with coresponding key
                    node.RemoveChild(node.SelectSingleNode(string.Format("//add[@key='{0}']", key)));
                    doc.Save(getConfigFilePath());
                }
            }
            catch (NullReferenceException e)
            {
                throw new Exception(string.Format("The key {0} does not exist.", key), e);
            }
        }

        private static XmlDocument loadConfigDocument()
        {
            XmlDocument doc = null;
            try
            {
                doc = new XmlDocument();
                doc.Load(getConfigFilePath());
                return doc;
            }
            catch (System.IO.FileNotFoundException e)
            {
                throw new Exception("No configuration file found.", e);
            }
        }

        private static string getConfigFilePath()
        {
            return Assembly.GetExecutingAssembly().Location + ".config";
        }
    }
}


