TITLE ASM-Paint

; This program creates a graphics box and paints a box inside
; key inputs paints block character up, down, left and right (q for quit),
; but we cannot paint out of the box

INCLUDE Irvine32.inc

Block = 0DBh
space = 20h

BlockColor = green+16*red
ScreenColor = lightGray+16*black

cornerX= 30
cornerY = 3

Box_height = 20
Box_width = 20

.data
xcord BYTE "X=", 0
ycord BYTE "Y=", 0
x BYTE ?
y BYTE ?

.code
main PROC

call MakeBox
mov DL, cornerX+1
mov DH, cornerY+1

;-----------------------Coordinate Print-------------------------------------

mov x, 1		
mov y, 1

Coordinate:
push EDX
mov DL, 0
mov DH, 0

call Gotoxy
mov EAX, ScreenColor
call SetTextColor

mov EDX, OFFSET xcord
call WriteString
mov AL, x
call WriteDec

mov AL, 20h			;after going left from 10, the 0 still appears after 9, so printing space over the 0
call WriteChar
call WriteChar

call Crlf

mov EDX, OFFSET ycord
call WriteString
mov AL, y
call WriteDec

mov AL, 20h			;after going up from 10, the 0 still appears after 9, so printing space over the 0
call Writechar
call WriteChar
pop EDX

;-------------------------Enter Decision Loop----------------------
GetKey:
call ReadChar	;waits for keystroke and puts it into AL
cmp AL, "u"		;If input = "u", go up
je Moveup
cmp AL, "d"		;If input = "d", go down
je MoveDown
cmp AL, "l"		;if input = "l", go left
je MoveLeft
cmp AL, "r"		;if input = "r", go right
je MoveRight
cmp AL, "1"		;If input = 1, paint BlockChar
je paint
cmp AL, "0"		;If input = 0, erase BlockChar
je erase
cmp AL, "q"		;if input = "q", quit
je Quit
jmp GetKey

;------------------Paint---------------------------------
paint:
mov EAX, red
call SetTextColor
call gotoxy
mov AL, Block
call WriteChar
jmp GetKey

;-------------------erase------------------------------------
erase:
call gotoxy
mov AL, space
call WriteChar
jmp GetKey

;-------------------Move Up------------------------------
MoveUp:
cmp DH, CornerY+1
je GetKey			;If at the top, we can't move up
dec DH				;Moving up, so dec y-coordinate by 1
dec y
call Gotoxy
jmp Coordinate

;--------------------Move Down----------------------------
MoveDown:
cmp DH, CornerY+Box_height	;if at the botton, can't move down
je GetKey
inc DH			;inc y-coordinate by 1
inc y
call gotoxy
jmp Coordinate

;---------------------Move Left--------------------------------
MoveLeft:
cmp DL, CornerX+1		;if at the left-most point, can't move left
je GetKey
dec DL				;dec x-coordinate by 1
dec x
call Gotoxy
jmp Coordinate

;-----------------------Move Right------------------------------
MoveRight:
cmp DL, CornerX+Box_width		;if at the right-most point, can't move right
je GetKey
inc DL		;inc x-coordinate by 1
inc x
call Gotoxy
jmp Coordinate

;----------------------Quit----------------------------------------

Quit:
mov DL, 5
mov DH, 0
call Gotoxy
mov EAX, ScreenColor
call SetTextColor

exit
main endp

;-----------------------------------------------------------------------
MakeBox PROC
; MakeBox displays a box in the middle of the console
; uses symbolic constants so nothing is passed
;-----------------------------------------------------------------------
mov EAX, BlockColor
call SetTextColor
mov AL, Block
;--------------------Top Line of Box----------------------------------
mov DH, CornerY
mov DL, CornerX
call Gotoxy
mov ECX, Box_width+2
L1:
	call WriteChar
	loop L1

;------------------Bottom Line of Box-------------------------------
mov DH, CornerY+Box_height+1
mov DL, CornerX
call Gotoxy
mov ECX, Box_width+2
L2:
	call WriteChar
	loop L2

;--------------------Left Side of Box--------------------------------
mov DH, CornerY
mov DL, CornerX
call Gotoxy
mov ECX, Box_height+2
L3:
	call WriteChar
	inc DH
	call Gotoxy
	loop L3

;----------------------Right side of Box----------------------------
mov DH, CornerY
mov DL, CornerX+Box_width+1
call Gotoxy
mov ECX, Box_height+2
L4:
	call WriteChar
	inc DH
	call Gotoxy
	loop L4
ret
MakeBox ENDP

end main