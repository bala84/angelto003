//----------------------------------------------------------------------------------------
// patterns & practices - Smart Client Software Factory - Guidance Package
//
// This file was generated by the "Add View" recipe.
//
// A presenter calls methods of a view to update the information that the view displays. 
// The view exposes its methods through an interface definition, and the presenter contains
// a reference to the view interface. This allows you to test the presenter with different 
// implementations of a view (for example, a mock view).
//
// For more information see:
// ms-help://MS.VSCC.v90/MS.VSIPCC.v90/ms.practices.scsf.2008apr/SCSF/html/02-09-010-ModelViewPresenter_MVP.htm
//
// Latest version of this Guidance Package: http://go.microsoft.com/fwlink/?LinkId=62182
//----------------------------------------------------------------------------------------

using System;
using Microsoft.Practices.ObjectBuilder;
using Microsoft.Practices.CompositeUI;
using Angel_to_003.Infrastructure.Interface;
using Microsoft.Practices.CompositeUI.EventBroker;
using System.Windows.Forms;
using Angel_to_003.Infrastructure.Interface.Constants;

namespace Angel_to_003.Infrastructure.Module
{
    public partial class TreeMainMenuViewPresenter : Presenter<ITreeMainMenuView>
    {

        [EventPublication(EventTopicNames.NodeMouseDoubleClick, PublicationScope.Global)]
        public event EventHandler<TreeNodeMouseClickEventArgs> NodeMouseDoubleClick;

        /// <summary>
        /// This method is a placeholder that will be called by the view when it has been loaded.
        /// </summary>
        public override void OnViewReady()
        {
            base.OnViewReady();
        }

        /// <summary>
        /// Close the view
        /// </summary>
        public override void OnCloseView()
        {
            base.CloseView();
        }

        /// <summary>
        /// ��������� ������� ������� �� ���� ������� ������� ����
        /// </summary>
        /// <param name="eventArgs"></param>
        public virtual void OnNodeMouseDoubleClick(TreeNodeMouseClickEventArgs eventArgs)
        {
            if (NodeMouseDoubleClick != null)
            {
                NodeMouseDoubleClick(this, eventArgs);
            }
        }
    }
}

