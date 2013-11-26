using Windows.UI.Xaml.Controls;
using VSMObserverPatternDemo.Models;
using VSMObserverPatternDemo.Observers;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace VSMObserverPatternDemo
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        private readonly Person _person;

        public MainPage()
        {
            this.InitializeComponent();
            _person = new Person();
            PersonPanel.DataContext = _person;
            _person.Attach(new StatusUpdater(Status));
            _person.Attach(new EmailFieldFormatter(Email));
        }
    }
}
