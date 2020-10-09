format PE console 4.0
entry start

include 'win32a.inc'

section 'code' code executable readable
        start:
        invoke printf,string1
        invoke scanf,INTEGER,age
        invoke printf,string2,[age]
        invoke scanf,INTEGER,age
        invoke ExitProcess,0
        ret

section 'data' data readable writeable
INTEGER db '%d',0

string1 db 'What is your age?',10,13,0
string2 db 'You age is %d!',10,13,0
age dd ?

section 'import' import readable writeable


library mcvcrt,'MSVCRT.DLL',\
        kernel,'KERNEL32.DLL'

import mcvcrt,\
        printf,'printf',\
        scanf,'scanf'

import kernel,\
        ExitProcess,'ExitProcess'









