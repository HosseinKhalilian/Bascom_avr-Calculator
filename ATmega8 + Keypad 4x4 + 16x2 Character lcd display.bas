'======================================================================='

' Title: LCD Display Calculator * Sound
' Last Updated :  02.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : ATmega8 + Keypad 4x4 + 16x2 Character lcd display

'======================================================================='

$regfile = "M8DEF.DAT"
$crystal = 1000000

Config Pinc.0 = Output
Config Pinc.1 = Output
Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Pinb.2 , Db5 = Pinb.3 , Db6 = Pinb.4 , Db7 = Pinb.5 , Rs = Pinb.0 , E = Pinb.1

Config Kbd = Portd , Debounce = 100 , Delay = 10

Dim K As Byte                                               ' ghofl
Dim A As Byte
Dim B as byte
Dim D As Byte
Dim C As Long
Dim E As Byte
Dim F As Long
Dim G As Long
Dim H As Word
Dim I As Single
Dim J As Word

Deflcdchar 0 , 32 , 17 , 10 , 4 , 10 , 17 , 32 , 32         ' *
Deflcdchar 1 , 32 , 4 , 32 , 31 , 32 , 4 , 32 , 32          ' /
Deflcdchar 3 , 32 , 32 , 32 , 31 , 32 , 32 , 32 , 32        ' -
Deflcdchar 4 , 32 , 4 , 4 , 31 , 4 , 4 , 32 , 32            ' +
Deflcdchar 5 , 32 , 32 , 32 , 31 , 32 , 31 , 32 , 32        ' =
Deflcdchar 6 , 32 , 17 , 10 , 4 , 10 , 17 , 32 , 32         ' Mid
Deflcdchar 7 , 32 , 3 , 4 , 4 , 4 , 3 , 32 , 32             ' Left
Deflcdchar 2 , 32 , 24 , 4 , 4 , 4 , 24 , 32 , 32           ' Right

Set Portc.0

Sound Portc.1 , 100 , 20
Sound Portc.1 , 100 , 40
Sound Portc.1 , 100 , 60
Sound Portc.1 , 100 , 80
Sound Portc.1 , 100 , 120
Sound Portc.1 , 100 , 140
Sound Portc.1 , 100 , 200

Wait 4
Cls
Cursor Off
Readeeprom K , 0

If K = 255 Then K = 0
If K > 200 Then Goto Lock

'-----------------------------------------------------------

Run:

Lcd "0"
B = 0
C = 0
E = 0

''''''''''''''''''''''''''''''

Main:
A = Getkbd()
If A = 16 Then Goto Main

''''''''''''''''''''''''''''''

Loop1:
D = Getkbd()
If D <> 16 Then Goto Loop1
B = Lookup(a , Keydata)

Select Case B

   Case 0 To 9:
   Cls
   Sound Portc.1 , 100 , 25
   I = 0
   J = 0
   C = C * 10
   C = C + B
   Lcd C
   If E = 0 Then F = C
   If E = 1 Then G = C

   Case 10:
   Sound Portc.1 , 100 , 35
   E = 1
   J = 0
   C = 0
   H = 0
   Locate 1 , 14
   Lcd Chr(1)
   Goto Main

   Case 11 :
   Sound Portc.1 , 100 , 45
   E = 1
   J = 0
   C = 0
   H = 1
   Locate 1 , 14
   Lcd Chr(0)
   Goto Main

   Case 12 :
   Sound Portc.1 , 100 , 55
   E = 1
   J = 0
   C = 0
   H = 2
   Locate 1 , 14
   Lcd Chr(3)
   Goto Main

   Case 13 :
   Sound Portc.1 , 100 , 65
   Incr J
   If J = 3 Then Goto ResetM
   Cls
   Locate 1 , 1
   Lcd "reset "
   Locate 2 , 1
   Lcd "calculator"
   Waitms 600
   Cls
   Goto Run

   Case 14:
   Sound Portc.1 , 100 , 150
   Waitms 30
   Sound Portc.1 , 100 , 150
   Waitms 30
   J = 0
   K = K + 1
   Writeeeprom K , 0
   Waitms 4
   If H = 0 Then Goto Ans1
   If H = 1 Then Goto Ans2
   If H = 2 Then Goto Ans3
   If H = 3 Then Goto Ans4

   Case 15 :
   Sound Portc.1 , 100 , 75
   J = 0
   E = 1
   C = 0
   H = 3
   Locate 1 , 14
   Lcd Chr(4)

   Goto Main
End Select

Goto Main

''''''''''''''''''''''''''''''

Ans1:
I = F / G
If G = 0 Then Goto Error1
Cls
Lcd F ; Chr(1) ; G ; Chr(5)
Locate 2 , 1
Lcd I
F = 0
G = 0
Goto Main

''''''''''''''''''''''''''''''

Ans2:
I = F * G
Cls
Lcd F ; Chr(0) ; G ; Chr(5)
Locate 2 , 1
Lcd I
F = 0
G = 0
Goto Main

''''''''''''''''''''''''''''''

Ans3:
I = F - G
Cls
Lcd F ; Chr(3) ; G ; Chr(5)
Locate 2 , 1
Lcd I
F = 0
G = 0
Goto Main

''''''''''''''''''''''''''''''

Ans4:
I = F + G
Cls
Lcd F ; Chr(4) ; G ; Chr(5)
Locate 2 , 1
Lcd I
F = 0
G = 0
Goto Main

''''''''''''''''''''''''''''''

ResetM:
Cls
F = 0
G = 0
Locate 1 , 1
Lcd "turn off=3s"
Wait 1
Locate 1 , 1
Lcd "turn off=2s"
Wait 1
Locate 1 , 1
Lcd "turn off=1s"
Wait 1
Cls
Locate 1 , 5
Lcd "Bye Bye"

Sound Portc.1 , 100 , 100
Sound Portc.1 , 100 , 80
Sound Portc.1 , 100 , 60
Sound Portc.1 , 100 , 40
Sound Portc.1 , 100 , 20
Sound Portc.1 , 100 , 10
Sound Portc.1 , 100 , 5
Wait 3
Display Off
Waitms 10
Reset Portc.0
Idle

''''''''''''''''''''''''''''''

Error1:
Cls
F = 0
G = 0
Locate 1 , 1
Lcd "CANNOT DIVIDE BY "
Locate 2 , 1
Lcd "ZERO !!!"
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Goto Main

''''''''''''''''''''''''''''''

Lock:
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Waitms 50
Sound Portc.1 , 100 , 50
Cls
Lcd "Lock"
Locate 2 , 6
Lcd "demo"
Wait 4

Goto Lock

''''''''''''''''''''''''''''''

Keydata:
Data 1 , 2 , 3 , 10 , 4 , 5 , 6 , 11 , 7 , 8 , 9 , 12 , 13 , 0 , 14 , 15

'-----------------------------------------------------------