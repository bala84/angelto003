﻿//----------------------------------------------------------------------------------------
// patterns & practices - Smart Client Software Factory - Guidance Package
//
// This file was generated by the "Add Business Module" recipe.
//
// This class contains placeholder methods for the common module initialization 
// tasks, such as adding services, or user-interface element
//
// For more information see: 
// ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-08-060-Add_Business_Module_Next_Steps.htm
//
// Latest version of this Guidance Package: http://go.microsoft.com/fwlink/?LinkId=62182
//----------------------------------------------------------------------------------------

using System;
using System.Windows.Forms;
using Angel_to_003.Infrastructure.Interface;
using Microsoft.Practices.CompositeUI;
using Microsoft.Practices.CompositeUI.Commands;
using Microsoft.Practices.CompositeUI.EventBroker;
using Angel_to_003.WarehouseOrderModule.Constants;
using Microsoft.Practices.CompositeUI.WinForms;

namespace Angel_to_003.WarehouseOrderModule
{
    public class ModuleController : WorkItemController
    {
        public override void Run()
        {
            AddServices();
            ExtendMenu();
            ExtendToolStrip();
            AddViews();
        }

        private void AddServices()
        {
            //TODO: add services provided by the Module. See: Add or AddNew method in 
            //		WorkItem.Services collection or see ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.2005Nov.cab/CAB/html/03-020-Adding%20Services.htm
        }

        private void ExtendMenu()
        {
            //TODO: add menu items here, normally by calling the "Add" method on
            //		on the WorkItem.UIExtensionSites collection. For an example 
            //		See: ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-04-340-Showing_UIElements.htm
        }

        private void ExtendToolStrip()
        {
            //TODO: add new items to the ToolStrip in the Shell. See the UIExtensionSites collection in the WorkItem. 
            //		See: ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-04-340-Showing_UIElements.htm
        }

        private void AddViews()
        {
            //TODO: create the Module views, add them to the WorkItem and show them in 
            //		a Workspace. See: ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/03-01-040-How_to_Add_a_View_with_a_Presenter.htm

            // To create and add a view you can customize the following sentence
            // SampleView view = ShowViewInWorkspace<SampleView>(WorkspaceNames.SampleWorkspace);

        }

        //TODO: Add CommandHandlers and/or Event Subscriptions
        //		See: ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-04-350-Registering_Commands.htm
        //		See: ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-04-320-Publishing_and_Subscribing_to_Events.htm
        /// <summary>
        /// Вызываем форму по подписке на событие, при условии, что вызвано верное событие
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="eventArgs"></param>
        [EventSubscription(Angel_to_003.Infrastructure.Interface.Constants.EventTopicNames.NodeMouseDoubleClick, ThreadOption.UserInterface)]
        public void OnNodeMouseDoubleClick(object sender, TreeNodeMouseClickEventArgs eventArgs)
        {
            TabSmartPartInfo tspinfo;

            if (eventArgs.Node.Name == "WarehouseOrder")
            {
                tspinfo = new TabSmartPartInfo();
                tspinfo.Title = eventArgs.Node.Text;
                WarehouseOrderMasterView womview = ShowViewInWorkspace<WarehouseOrderMasterView>(Angel_to_003.Infrastructure.Interface.Constants.WorkspaceNames.RightWorkspace);
                WorkItem.Workspaces.Get(Angel_to_003.Infrastructure.Interface.Constants.WorkspaceNames.RightWorkspace)
                .ApplySmartPartInfo(
                          WorkItem.Workspaces.Get(Angel_to_003.Infrastructure.Interface.Constants.WorkspaceNames.RightWorkspace).ActiveSmartPart
                        , tspinfo);

            }
        }
    }
}
