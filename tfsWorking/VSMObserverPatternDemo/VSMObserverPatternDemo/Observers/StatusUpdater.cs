using VSMObserverPatternDemo.Models;
using Windows.UI.Xaml.Controls;

namespace VSMObserverPatternDemo.Observers
{
    public class StatusUpdater : Interfaces.IObserver<EmailChangedEventArgs>
    {
        private readonly TextBlock _statusElement;

        public StatusUpdater(TextBlock statusElement)
        {
            _statusElement = statusElement;
        }

        public void Update(object sender, EmailChangedEventArgs e)
        {
            _statusElement.Text = string.Format("Email address changed to: {0}", e.Email);
        }
    }
}
