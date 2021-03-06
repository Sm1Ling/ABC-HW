format PE console
include 'win32a.inc'
entry start

section 'data' data readable writeable

        EnterString db 'Write the string',10,0    ;������ ��� ������ 10 - ����������� �������� �� ����� ������, 0 - ����������� ����� ������
        YourString db 'Your String: ',10,0   ; ������ ����� ������������ ����� ������ ��� ���� ��������� � ��� ����� ��������������
        MString db 'Modified String: ',10,0 ;����� ������������ ����� ������ ��� ��� �����
        estring db '',10,0
        tempString  db '%s', 0         ;��� ����� �����   %s - ������ ���� ����� ������������ ������
        A db 256 dup(?) ; ������ ��� �������� ���� ��������� ������
        B db 256 dup(?) ; ������ ��� �������� ���� � ������������ ������

section 'text' code executable readable
start:
        push EnterString ; �������� � ���� ����������
        call [printf]  ; ��������� ������� ����� ��������� �� ����� �� �������� pop

        push A
        push tempString
        call [scanf] ; ����� ������� ���������� ������ � ����������� �� � ������


        push YourString
        call [printf]

        push A
        call [printf]
        push estring
        call [printf]

        push B
        push A
        call toLower  ; ����� ������ ������������ toLower




        push MString
        call [printf] ; ����� ����������
        push B
        call [printf]

        call [getch] ; �������� ������� �������

        push 0
        call [ExitProcess]

proc toLower inputLine, outputLine   ;�������� �������� ������� � �� ����������

        mov edi,[inputLine] ; ������� � edi ������ �� ������ ���� ������� inputLine  (inputLine ��� ���������� � ������� ����� A)

        mov ecx,256 ; �������� ��� ����� rep (���� ����� ������).  rep �������� �� ���� ���� ��� ecx ����������� �� 1 ��� ������ �������� �����

        xor al,al ; ������� ������� �������� ������� �� � ������� �������� scasb ��� ����������� ����� ������ (���������� ������� ������� � edi � al)
        repnz scasb  ; repz - ��������� ���� ���� Zflag = true, repnz - ���� Zflag =false

        sub edi,[inputLine]  ; inputLine ��������� �� ������� ������ ������. edi ��� ��������� �� ����� ������. ������� �� edi inputLine ����� ������ ���������� ��������
        sub edi,1 ; ��� ����

        mov ecx,edi ; ������ �� ����� ����� ������ ������

        mov eax,[inputLine] ; ������� �� ������ inputLine
        mov ebx,[outputLine] ; ������� �� ������ outputLine

                      ; ++++ eax ebx edx ecx esi edi    ����� ����
                       ;  ++ ax   bx  dx  cx  si  di
                        ; +  ah   bh  dh  ch
                         ; + al   bl  dl  cl
        .loop:
        mov dl,[eax] ; al �������� �� ������� ���� � eax ������� ���� ������ ���, �� ������ � eax

        cmp dl,'A' ; ��������� �������� dl � ��������� ���� inputLine
        jb .skip ; jl ��� signed ����������, jb ��� unsigned ���������� (�������� �� ���� ���������). ���� �������� �������, �� ��������� � .skip

        cmp dl,'Z'
        ja .skip ; ja unsigned , jg signed (������)
        ;���� ��� ������� �� ������, ������ ���� ��������� ��������� �����
        add dl,'a'-'A'  ; �������� ������� ���� ����� �������� ������ ���� �� ������� ASCII

        .skip:
        mov [ebx], dl ; �������� �������� inputLine ����� dl � outputLine
        add eax,1
        inc ebx    ;������ ������� ��������� sub eax,-1 �

        loop .loop  ; ������� loop ��������� ecx �� 1 � ���� �� �� ����� 0 �� ��������� � .loop

        ret
endp ; �������� ������� proc





section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess'

  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'

