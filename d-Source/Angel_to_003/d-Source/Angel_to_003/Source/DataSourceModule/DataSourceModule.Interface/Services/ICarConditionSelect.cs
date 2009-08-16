using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Angel_to_003.DataSourceModule.Interface.Schema;

namespace Angel_to_003.DataSourceModule.Interface.Services
{
    public interface ICarConditionSelect
    {
        List<uspVCAR_CONDITION_SelectCarResult> uspVCAR_CONDITION_SelectCar();
        List<uspVCAR_CONDITION_SelectFreightResult> uspVCAR_CONDITION_SelectFreight();
    }
}
