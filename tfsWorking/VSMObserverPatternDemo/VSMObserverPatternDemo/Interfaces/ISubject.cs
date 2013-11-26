using System;

namespace VSMObserverPatternDemo.Interfaces
{
    public interface ISubject<out T>
        where T: EventArgs
    {
        void Attach(IObserver<T> observer);
        void Detach(IObserver<T> observer);
    }
}
