using System;
using System.Collections.Generic;
using System.Text;

namespace Angel_to_001
{
    //Класс констант
    public static class Const
    {
        //Константы Грузового и Легкового автомобиля
        public const byte Freight = 31;
        public const byte Car = 30;
        //Константы Сезонов
        public const byte Winter = 40;
        public const byte Spring = 41;
        public const byte Summer = 42;
        public const byte Autumn = 43;
        //Константы видов путевых листов
        public const byte Car_driver_list_type_id = 60;
        public const byte Freight_driver_list_type_id = 61;
        public const string Car_driver_list_type_sname = "Форма №3";
        public const string Freight_driver_list_type_sname = "Форма №4П";
        //Константы организации
        public const int Organization_l1_id = 1011;
        public const int Organization_l2_id = 1015;
        public const string Organization_l1_name = "Лидер-1";
        public const string Organization_l2_name = "Лидер-2";

        //Константы состояний путевых листов
        public const byte Opened_driver_list_state_id = 70;
        public const byte Closed_driver_list_state_id = 71;
        //Константы видов автомобилей
        public const string Evacuator_sname = "Эвакуатор";
        public const byte Evacuator = 50;
        public const byte MTO = 51;
        //Поиск по префиксу
        public const byte Pt_search = 201;
        //Top n by Rank для поиска
        public const byte Top_n_by_rank = 100;
        //Энергоустановка
        public const byte Power_trailer_id = 90;
        public const string Power_trailer = "Энергоустановка";
        
        //Состояние автомобиля "В ремзоне"
        public const short In_repair_zone_id = 301;
        public const string In_repair_zone_name = "В ремзоне";

        //Состояние автомобиля "На линии"
        public const short On_duty_id = 302;
        public const string On_duty_name = "На линии";

        //Состояние автомобиля "На стоянке"
        public const short In_garage_id = 303;
        public const string In_garage_name = "На стоянке";
        
        
        //Тип требования 
        public const short Wrh_demand_master_type_car_id = 401;
        public const string Wrh_demand_master_type_car_sname = "По машине";
        
        public const short Wrh_demand_master_type_worker_id = 402;
        public const string Wrh_demand_master_type_worker_sname = "Для механиков";
        
        public const short Wrh_demand_master_type_expense_id = 403;
        public const string Wrh_demand_master_type_expense_sname = "Расход";
        
        public const short Wrh_demand_master_type_motor_id = 404;
        public const string Wrh_demand_master_type_motor_sname = "Моторный цех";
        
         //Тип заказа-наряда 
        public const short Wrh_order_master_type_car_id = 401;
        public const string Wrh_order_master_type_car_sname = "По машине";
        
        public const short Wrh_order_master_type_worker_id = 402;
        public const string Wrh_order_master_type_worker_sname = "Для механиков";
        
        public const short Wrh_order_master_type_expense_id = 403;
        public const string Wrh_order_master_type_expense_sname = "Расход";
        
        public const short Wrh_order_master_type_motor_id = 404;
        public const string Wrh_order_master_type_motor_sname = "Моторный цех";
        //Тип должностей
        public const short Emp_type_mech_id = 1008;
        public const short Emp_type_mech_manager_id = 1011;
        public const short Emp_type_header_id = 1009;
        //Организациии
        public const short Org_rmz_id = 1200;
        //Типы ремонтов
        public const short To_repair_type = 410;
        public const short Addtnl_to_repair_type = 411;
        public const short Common_repair_type = 412;
        public const short Addtnl_repair_type = 413;
        
    }
}
