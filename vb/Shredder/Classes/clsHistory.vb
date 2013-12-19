' Requirements: UrlHist interface library
'               clsURLHistItem

Option Explicit On 
Imports Shredder.UrlHistory

Public Class clsHistory

    Private _History As urlHistory
    Private _URLs As Collection

    Public Function Clear()
        _History = New UrlHistory
        _History.ClearHistory()
        RefreshHistory()
    End Function

    Public Function RefreshHistory()
        Dim IEnm As IEnumSTATURL
        Dim STAT As STATURL
        Dim c As Long
        Dim URL As clsURLHistItem

        IEnm = _History.EnumUrls

        ' Release the previous collection
        ' and create a new one
        _URLs = New Collection

        ' Enumerate URLs
        Do Until IEnm.Next(, STAT) = 0

            ' Create a new URLHistoryItem
            ' object
            URL = New clsURLHistItem()

            ' Initialize the URL object
            URL.Init(STAT)

            ' Add the URLHistoryItem object
            ' to the collection
            _URLs.Add(URL)

        Loop

        ' Release the enumerator object
        IEnm = Nothing

    End Function

End Class
