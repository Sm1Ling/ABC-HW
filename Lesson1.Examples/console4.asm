format  PE console 4.0 ;working
    include 'D:\Applications\ASSembler\INCLUDE\win32a.inc'
;-------------------------------------------------------------------
;                               Start:
;-------------------------------------------------------------------
start:  cinvoke printf, sent0
   ; cinvoke scanf, sent4, A
    mov [A], eax
    mov eax, dword[Array1+1]
    mov [A], eax
 
    cinvoke printf, A
 
    invoke  _getch
    invoke  exit, 0
;-------------------------------------------------------------------
;                               Data:
;-------------------------------------------------------------------
    sent0   db 'Enter A:', 0
    sent4   db 'Punyan?', 0
    A   dd ?
    Array1 db 1d,2d,3d,4d,5d,6d,7d,8d,9d,10d,0
 
;-------------------------------------------------------------------
;                               Import:
;-------------------------------------------------------------------
    data    import
 
    library msvcrt,'MSVCRT.DLL';,\
 
    import  msvcrt,\
    _getch,'_getch',\
    scanf,'scanf',\
    printf,'printf',\
    exit,'exit'
    end data