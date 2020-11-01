format PE console
include 'win32a.inc'
entry start

section 'data' data readable writeable

        EnterString db 'Write the string',10,0    ;Строки для вывода 10 - модификатор перехода на новую строку, 0 - модификатор конца строки
        YourString db 'Your String: ',10,0   ; строка чтобы пользователь точно увидел что ввел правильно и что будет обрабатываться
        MString db 'Modified String: ',10,0 ;чтобы пользователь точно догнал что это вывод
        estring db '',10,0
        tempString  db '%s', 0         ;Для ввода строк   %s - значит туда могут передаваться строки
        A db 256 dup(?) ; массив для хранения букв введенной строки
        B db 256 dup(?) ; массив для хранения букв с обработанной строки

section 'text' code executable readable
start:
        push EnterString ; передача в стек параметров
        call [printf]  ; некоторые функции берут параметры из стека по принципу pop

        push A
        push tempString
        call [scanf] ; вызов функции считывания строки и записывания ее в массив


        push YourString
        call [printf]

        push A
        call [printf]
        push estring
        call [printf]

        push B
        push A
        call toLower  ; вызов метода аналогичного toLower




        push MString
        call [printf] ; вывод результата
        push B
        call [printf]

        call [getch] ; ожидание нажатия клавиши

        push 0
        call [ExitProcess]

proc toLower inputLine, outputLine   ;объявляю название функции и ее переменную

        mov edi,[inputLine] ; передаю в edi ссылку на первый байт массива inputLine  (inputLine это переменная в которой лежит A)

        mov ecx,256 ; итератор для цикла rep (макс длина строки).  rep работает за счет того что ecx уменьшается на 1 при каждой итерации цикла

        xor al,al ; заданию нулевое значение региста ал с которым работает scasb для определения конца строки (сравнивает текущий элемент в edi с al)
        repnz scasb  ; repz - повторяет цикл пока Zflag = true, repnz - пока Zflag =false

        sub edi,[inputLine]  ; inputLine указывает на позицию начала строки. edi уже указывает на конец строки. отнимаю от edi inputLine чтобы узнать количество символов
        sub edi,1 ; так надо

        mov ecx,edi ; теперь мы точно знаем размер строки

        mov eax,[inputLine] ; регистр на начало inputLine
        mov ebx,[outputLine] ; регистр на начало outputLine

                      ; ++++ eax ebx edx ecx esi edi    пусть буит
                       ;  ++ ax   bx  dx  cx  si  di
                        ; +  ah   bh  dh  ch
                         ; + al   bl  dl  cl
        .loop:
        mov dl,[eax] ; al отвечает за младший байт в eax поэтому если изменю его, то изменю и eax

        cmp dl,'A' ; сравниваю значение dl с значением чара inputLine
        jb .skip ; jl для signed переменных, jb для unsigned переменных (проверка на флаг сравнения). Если проходит условие, то переходим в .skip

        cmp dl,'Z'
        ja .skip ; ja unsigned , jg signed (больше)
        ;если эти условия не прошли, значит надо уменьшить заглавную букву
        add dl,'a'-'A'  ; добавляю сколько надо чтобы получить нужный знак из таблицы ASCII

        .skip:
        mov [ebx], dl ; вставляю значение inputLine через dl в outputLine
        add eax,1
        inc ebx    ;разные способы увеличить sub eax,-1 ы

        loop .loop  ; команда loop уменьшает ecx на 1 и если он не равен 0 то переходит в .loop

        ret
endp ; закрытие макроса proc





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

