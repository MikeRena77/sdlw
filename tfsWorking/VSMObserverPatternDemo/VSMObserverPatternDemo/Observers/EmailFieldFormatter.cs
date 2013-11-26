using VSMObserverPatternDemo.Models;
using Windows.UI;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media;

namespace VSMObserverPatternDemo.Observers
{
    public class EmailFieldFormatter : Interfaces.IObserver<EmailChangedEventArgs>
    {
        private readonly TextBox _emailField;

        public EmailFieldFormatter(TextBox emailField)
        {
            _emailField = emailField;
        }

        public void Update(object sender, EmailChangedEventArgs e)
        {
            var highlightColor = Color.FromArgb(255, 255, 255, 255);

            if (!string.IsNullOrEmpty(e.Email))
            {
                highlightColor = Color.FromArgb(255, 255, 255, 0);
            }

            _emailField.Background = new SolidColorBrush(highlightColor);
        }
    }
}
