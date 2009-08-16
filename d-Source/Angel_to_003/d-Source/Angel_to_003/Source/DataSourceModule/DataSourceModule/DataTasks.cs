using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Angel_to_003.DataSourceModule.Interface.Schema;

namespace Angel_to_003.DataSourceModule
{
    public static class DataTasks
    {
        /// <summary>
        /// Процедура возвращает данные о состоянии легковых автомобилей
        /// </summary>
        /// <returns></returns>
        public static List<uspVCAR_CONDITION_SelectCarResult> uspVCAR_CONDITION_SelectCar()
        {
           using (DataClassesDataContext db = new DataClassesDataContext())
           {
               return (from t in db.uspVCAR_CONDITION_SelectCar(null, null, "", null, null) 
                       select t).ToList<uspVCAR_CONDITION_SelectCarResult>();
           }
        }
        /// <summary>
        /// Процедура возвращает данные о состоянии грузовых автомобилей
        /// </summary>
        /// <returns></returns>
        public static List<uspVCAR_CONDITION_SelectFreightResult> uspVCAR_CONDITION_SelectFreight()
        {
            using (DataClassesDataContext db = new DataClassesDataContext())
            {
                return (from t in db.uspVCAR_CONDITION_SelectFreight(null, null, "", null, null)
                        select t).ToList<uspVCAR_CONDITION_SelectFreightResult>();
            }
        }

    }
}
