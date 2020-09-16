format PE console 4.0
entry start
include 'win32a.inc'
d equ dword
section '.text' code readable executable
start:

        stdcall Power,625.0,0.25
        invoke printf,INTEGER,eax
        invoke scanf,STRING,buffer
Exit:
        invoke ExitProcess,0

proc Power num,power
        locals
          pow dd ?
          rou dd ?
        endl
                fld [power]
                fld [num]
                fyl2x
                fld st0
                frndint
                fxch st1
                fsub st0,st1
                f2xm1
                fld1
                faddp st1,st0
                fscale
                fistp d[num]
        mov eax,[num]
        ret
endp
section '.data' data readable writeable
STRING db '%s',0
INTEGER db '%d',0
buffer db 256 dup(?)
section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
          mcv,'msvcrt.dll'
  import mcv,\
         printf,'printf',\
         scanf,'scanf'
  import kernel,\
         ExitProcess,'ExitProcess'