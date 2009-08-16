using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Angel_to_003.DataSourceModule.Interface.Services;
using Angel_to_003.DataSourceModule.Interface.Schema;

namespace Angel_to_003.DataSourceModule.Services
{
    public class CarConditionSelect : ICarConditionSelect
    {
        /// <summary>
        /// Сервис для получения данных о легковых автомобилях
        /// </summary>
        /// <returns></returns>
        public List<uspVCAR_CONDITION_SelectCarResult> uspVCAR_CONDITION_SelectCar()
        {
            return DataTasks.uspVCAR_CONDITION_SelectCar();
        }
        /// <summary>
        /// Сервис для получения данных о грузовых автомобилях
        /// </summary>
        /// <returns></returns>
        public List<uspVCAR_CONDITION_SelectFreightResult> uspVCAR_CONDITION_SelectFreight()
        {
            return DataTasks.uspVCAR_CONDITION_SelectFreight();
        }
    }
}
