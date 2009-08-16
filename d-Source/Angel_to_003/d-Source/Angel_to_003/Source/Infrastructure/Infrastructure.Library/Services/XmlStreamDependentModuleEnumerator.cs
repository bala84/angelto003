﻿//----------------------------------------------------------------------------------------
// patterns & practices - Smart Client Software Factory - Guidance Package
//
// This file was generated by this guidance package as part of the solution template
//
// The XmlStreamDependentModuleEnumerator class provides an implementation of IModuleEnumerator
// that is used to retrieve an array of IModuleInfo. This service depends on the IModuleInfoStore service
// that provides the storage of the profile catalog
// 
// For more information see: 
// ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/03-01-010-How_to_Create_Smart_Client_Solutions.htm
//
// Latest version of this Guidance Package: http://go.microsoft.com/fwlink/?LinkId=62182
//----------------------------------------------------------------------------------------

using System;
using System.Xml;
using Angel_to_003.Infrastructure.Library.Properties;
using Angel_to_003.Infrastructure.Library.Services;
using Microsoft.Practices.CompositeUI;
using Microsoft.Practices.CompositeUI.Configuration;
using Microsoft.Practices.CompositeUI.Services;

namespace Angel_to_003.Infrastructure.Library.Services
{
    /// <summary>
    /// This implementation of IModuleEnumerator processes the assemblies specified
    /// in a solution profile.
    /// </summary>
    public class XmlStreamDependentModuleEnumerator : IModuleEnumerator
    {
        private IModuleInfoStore _moduleInfoStore;

        /// <summary>
        /// Initializes a new instance of the <see cref="T:XmlStreamDependentModuleEnumerator"/> class.
        /// </summary>
        public XmlStreamDependentModuleEnumerator()
        {
        }

        [ServiceDependency]
        public IModuleInfoStore ModuleInfoStore
        {
            get { return _moduleInfoStore; }
            set { _moduleInfoStore = value; }
        }

        /// <summary>
        /// Gets an array of <see cref="T:Microsoft.Practices.CompositeUI.Configuration.IModuleInfo"/>
        /// enumerated from the source the enumerator is processing.
        /// </summary>
        /// <returns>
        /// An array of <see cref="T:Microsoft.Practices.CompositeUI.Configuration.IModuleInfo"/> instances.
        /// </returns>
        public IModuleInfo[] EnumerateModules()
        {
            string xml = _moduleInfoStore.GetModuleListXml();

            if (String.IsNullOrEmpty(xml))
                return new DependentModuleInfo[0];

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml);

            switch (doc.FirstChild.NamespaceURI)
            {
                case SolutionProfileV1Parser.Namespace:
                    return new SolutionProfileV1Parser().Parse(xml);

                case SolutionProfileV2Parser.Namespace:
                    return new SolutionProfileV2Parser().Parse(xml);

                default:
                    throw new InvalidOperationException(Resources.InvalidSolutionProfileSchema);
            }
        }
    }
}
