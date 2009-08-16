using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Angel_to_003.Infrastructure.Interface.Constants
{
    /// <summary>
    /// Этот класс предназначен для хранения констант политик обработки исключений
    /// </summary>
    public class ExceptionPolicyNames
    {
        public const string DataAccessExceptionPolicy = "DataAccessExceptionPolicy";
        public const string LoggingOnlyExceptionPolicy = "LoggingOnlyExceptionPolicy";
        public const string ReplaceExceptionPolicy = "ReplaceExceptionPolicy";
        public const string WrapExceptionPolicy = "WrapExceptionPolicy";
        public const string PropagateExceptionPolicy = "PropagateExceptionPolicy";
    }
}
