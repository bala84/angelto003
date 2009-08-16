using System;
using Microsoft.Practices.CompositeUI.EventBroker;
using Angel_to_003.Infrastructure.Interface;
using Angel_to_003.Infrastructure.Interface.Constants;

namespace Angel_to_003.Infrastructure.Layout
{
    public class ShellLayoutViewPresenter : Presenter<ShellLayoutView>
    {
        [EventPublication(EventTopicNames.CancelToolStripButtonClick, PublicationScope.Global)]
        public event EventHandler<EventArgs> CancelToolStripButtonClick;
    
        [EventPublication(EventTopicNames.OkToolStripButtonClick, PublicationScope.Global)]
        public event EventHandler<EventArgs> OkToolStripButtonClick;
    
        protected override void OnViewSet()
        {
            WorkItem.UIExtensionSites.RegisterSite(UIExtensionSiteNames.MainMenu, View.MainMenuStrip);
            WorkItem.UIExtensionSites.RegisterSite(UIExtensionSiteNames.MainStatus, View.MainStatusStrip);
            WorkItem.UIExtensionSites.RegisterSite(UIExtensionSiteNames.MainToolbar, View.MainToolbarStrip);
        }

        /// <summary>
        /// Status update handler. Updates the status strip on the main form.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The e.</param>
        [EventSubscription(EventTopicNames.StatusUpdate, ThreadOption.UserInterface)]
        public void StatusUpdateHandler(object sender, EventArgs<string> e)
        {
            View.SetStatusLabel(e.Data);
        }

        /// <summary>
        /// Called when the user asks to exit the application.
        /// </summary>
        public void OnFileExit()
        {
            View.ParentForm.Close();
        }
        /// <summary>
        /// Called when the user asks to exit the form
        /// </summary>
        public override void  OnCloseView()
        {
 	        base.OnCloseView();
           // View.RightWorkspace.SelectedTab.
        }
        /// <summary>
        /// Вызываем, когда нажимаем кнопку "Ок"
        /// </summary>
        /// <param name="eventArgs"></param>
        public virtual void OnOkToolStripButtonClick(EventArgs eventArgs)
        {
            if (OkToolStripButtonClick != null)
            {
                OkToolStripButtonClick(this, eventArgs);
            }
        }
        /// <summary>
        /// Вызываем, когда нажимаем кнопку "Отмена"
        /// </summary>
        /// <param name="eventArgs"></param>
        public virtual void OnCancelToolStripButtonClick(EventArgs eventArgs)
        {
            if (CancelToolStripButtonClick != null)
            {
                CancelToolStripButtonClick(this, eventArgs);
            }
        }
    }
}
