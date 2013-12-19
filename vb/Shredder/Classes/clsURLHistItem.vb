' Requirements: UrlHist interface library

Option Explicit On 
Imports Shredder.UrlHistory

Public Class clsURLHistItem
    Private _MyStat As STATURL

    ' Initializes the object data
    Public Function Init(ByVal STAT As STATURL)
        _MyStat = STAT
    End Function

End Class
