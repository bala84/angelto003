﻿//----------------------------------------------------------------------------------------
// patterns & practices - Smart Client Software Factory - Guidance Package
//
// This file was generated by this guidance package as part of the solution template
//
// The EntityTranslatorException is used by the EntityTranslatorService
//
// For more information see: 
// ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/03-01-010-How_to_Create_Smart_Client_Solutions.htm
//
// Latest version of this Guidance Package: http://go.microsoft.com/fwlink/?LinkId=62182
//----------------------------------------------------------------------------------------

using System;

namespace Angel_to_003.Infrastructure.Interface.Services
{
    [Serializable]
    public class EntityTranslatorException : Exception
    {
        public EntityTranslatorException() : base() { }
        public EntityTranslatorException(string message) : base(message) { }
        public EntityTranslatorException(string message, Exception innerException) : base(message, innerException) { }
    }
}
