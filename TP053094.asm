.model small
.386
.stack 512h
.data
    mainMenu db 10,"------MAIN MENU------",10
             db "1. Nasi Ayam",10
             db "2. Burger Meal",10
             db "3. Cupcake",10
             db "4. Coffee",10
             db "5. Statistics (Stocks, Balance)",10
             db "6. Exit",10
             db 10,"Enter your choice: $"
             
    invalidInput db "Invalid Input! Try again$"
    
    choice db 1 dup("$")
    
    greeting db "Welcome back, $"
    
    adminMessage db "Admin Name: $"
    
    adminName db 30 dup("$")

    newline db  10, "$"          ; a new line
    
    selection db "You have selected: $"
 
    mealOne db "Nasi Ayam$"
    
    mealTwo db "Burger Meal$"
    
    pastry db "Cupcake$"
    
    drink db "Coffee$"
    
    priceOne db 8
    
    priceTwo db 10
    
    priceThree db 5
    
    priceFour db 6
    
    stockOne db 99
    
    stockTwo db 99
    
    stockThree db 99
    
    stockFour db 99
    
    stock db 10,"Available stock: $"
    
    promptQuantity db " RM per Unit - How many of this unit: $"
    
    quantity db 0
    
    total db 0
    
    earnings db 0
    
    promptPayment db 10,10,"Price: RM $"
  
    paid db ?
    
    remaining  db "Remaining: RM $"
                    
    invalidRem db "The amount entered is less than the subtotal!",10,"$"
               
    anyKeyPrompt db 10,10,"Press any key to continue...",10,10,"$" ; for multi purposes
    
    payPrompt db "Enter the given amount: RM $"
    
    stockCheck  db " (Units Left): $"
    
    earningsPrompt db 10,"+ Today's earnings: RM $"
    
    leaveNote db 10,10,"Purchase Completed, Next Person :)$" ; After a person has purchased
    
    statistics db "------Statistics------",10,10,"$"
    
    astespace db "* $"
    
    timing db 10,"Time of Purchase: $"
        
.code

MAIN PROC
    
    mov ax, @DATA
    mov ds, ax                          ; set DS to point to the data segment.
    
    mov ah, 09h               
    mov dx, OFFSET adminMessage         ; promts name message 
    int 21h                   
    mov byte ptr adminName, 21
    mov dx, OFFSET adminName            ; scans admin name        
    mov ah, 0Ah
    int 21h

Menu:    
    mov al, 03h                         ; clears screen
    mov ah, 00h
    int 10h 
    
    mov ah, 09h
    mov dx, OFFSET greeting             ; prompts greeting message
    int 21h
    mov SI, 0002
    lea DX, adminName[SI]               ; prints admin name
    mov ah, 09h
    int 21h  
          
    mov ah, 09h    
    mov dx,offset newline               ; goes to next line
    int 21h 
          
    mov ah, 09h
    mov dx, OFFSET mainMenu             ; prints the main menu
    int 21h

    mov ah, 01h                         ; Store variable choice
    int 21h
    mov choice,al
    
    mov al, 03h                         ; clears screen
    mov ah, 00h
    int 10h 
    
    cmp choice, '1'                     ; if choice == 1
    je choiceOne

    cmp choice, '2'
    je choiceTwo
    
    cmp choice, '3'
    je choiceThree
    
    cmp choice, '4'
    je choiceFour
    
    cmp choice, '5'
    je choiceFive
    
    cmp choice, '6'
    je exit
    
    jne Menu                            ; else -> back to main menu
    
choiceOne:
    mov ah, 09h
    mov dx, OFFSET selection
    int 21h
    mov ah, 09h
    mov dx, OFFSET mealOne
    int 21h
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h

    mov ah, 09h
    mov dx, OFFSET stock                 ; Displays available amount of meals
    int 21h
    
    mov al, stockOne                     ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov al, priceOne                     ; Prints the price of the item
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h

    mov dx, OFFSET promptQuantity        ; Prints Quantity: 
    mov ah, 09h
    int 21h

    mov ah,01h                           ; Reads Quantity
    int 21h
    sub al, 48
    mov quantity,al
    
    mov ah, 09h
    mov dx, OFFSET promptPayment
    int 21h
    
    mov al, priceOne                    ; This operation is used to calculate the total
    mul quantity                        ; The total is quantity x price
    mov total, al
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h

    mov ah, 09h
    mov dx, OFFSET newline
    int 21h  
    
    mov ah, 09h
    mov dx, OFFSET payPrompt        ; Prints price
    int 21h  
    
    mov bh, 0
    mov bl, 10d
    
scanch:                             ; Reads a single digit
    mov ah, 01h
    int 21h
    cmp al, 13d                     ; if user presses Enter it stops reading
    jne storech                     ; otherwise, it keeps reading
    jmp stopReading
    
storech:                            ; Stores each character after reading
    sub al, 30h
    mov cl, al
    mov al, bh
    mul bl
    add al, cl
    mov bh, al
    mov paid, al  
    
    jmp scanch                      ; Goes back to reading a character after storing the previous character (Recursion)
    
stopReading:
    mov al, paid                    ; Moving paid variable into variable for comparison
    mov bl, total                   ; Moving total variable into variable for comparison
    
    cmp al, bl
    jae validPayment 
    
    cmp al, bl
    jnae invalidPayment
    
validPayment:
    
    sub al, bl                      ; Subtract the total from paid amount to get the remaining amount
    
    mov ah, 09h    
    mov dx, OFFSET remaining        ; prints the remaining message
    int 21h
    
    aam
    add ax, 3030h
    
    mov dh, al
    mov dl, ah
    mov ah, 02h
    int 21h
    
    mov dl, dh
    mov ah, 02h
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET timing           ; Prompts time message
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, ch                      ; Gets hour in ch
    aam 
    mov bx, ax
    call showTime
    
    mov dl, ':'                     ; Separates hour and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, cl                      ; Gets minute in ch
    aam 
    mov bx, ax
    call showTime                   ; Call procedure
    
    mov dl, ':'                     ; Separates second and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Gets seconds
    int 21h
    mov al, dh
    aam
    mov bx, ax
    call showTime
    
    mov ah, 09h
    mov dx, OFFSET leaveNote        ; After a completed purchase
    int 21h

    mov ah, 09h
    mov dx, OFFSET anyKeyPrompt
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
   
    mov al, stockOne
    mov bl, quantity
    sub al, bl
    mov stockOne, al
    
    mov al, earnings
    mov bl, total
    add al, bl
    mov earnings, al
    
    mov ah, 01h
    int 21h
    
    jmp Menu  
    
invalidPayment:                 ; In case the paid amount is less than the total amount

    mov ah, 06h                 ; Navigates the cursor to the uppermost pointer
    xor al, al                  ; cls
    xor cx, cx                  ; the beginning of the window
    mov dx, 184fh               ; the end of the window
    mov bh, 04h                 ; Red color font on black window
    int 10h                     ; BIOS
    
    mov ah, 09h    
    mov dx, OFFSET invalidRem
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET anyKeyPrompt
    int 21h
    
    mov ah, 01h
    int 21h
    
    jmp Menu      
    
choiceTwo:
    mov ah, 09h
    mov dx, OFFSET selection
    int 21h
    mov ah, 09h
    mov dx, OFFSET mealTwo
    int 21h
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h

    mov ah, 09h
    mov dx, OFFSET stock                 ; Displays available amount of meals
    int 21h
    
    mov al, stockTwo                     ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov al, priceTwo                     ; Prints the price of the item
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h

    mov dx, OFFSET promptQuantity        ; Prints Quantity: 
    mov ah, 09h
    int 21h

    mov ah,01h                           ; Reads Quantity
    int 21h
    sub al, 48
    mov quantity,al
    
    mov ah, 09h
    mov dx, OFFSET promptPayment
    int 21h
    
    mov al, priceTwo                    ; This operation is used to calculate the total
    mul quantity                        ; The total is quantity x price
    mov total, al
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h  
    
    mov ah, 09h
    mov dx, OFFSET payPrompt        ; Prints price
    int 21h  
    
    mov bh, 0
    mov bl, 10d
    
scanch2:                            ; Reads a single digit
    mov ah, 01h
    int 21h
    cmp al, 13d                     ; if user presses Enter it stops reading
    jne storech2                    ; otherwise, it keeps reading
    jmp stopReading2
    
storech2:                           ; Stores each character after reading
    sub al, 30h
    mov cl, al
    mov al, bh
    mul bl
    add al, cl
    mov bh, al
    mov paid, al  
    
    jmp scanch2                     ; Goes back to reading a character after storing the previous character (Recursion)
    
stopReading2:
    mov al, paid                    ; Moving paid variable into variable for comparison
    mov bl, total                   ; Moving total variable into variable for comparison
    
    cmp al, bl
    jae validPayment2 
    
    cmp al, bl
    jnae invalidPayment
    
validPayment2:
    sub al, bl                      ; Subtract the total from paid amount to get the remaining amount
    
    mov ah, 09h    
    mov dx, OFFSET remaining        ; prints the remaining message
    int 21h
    
    aam
    add ax, 3030h
    
    mov dh, al
    mov dl, ah
    mov ah, 02h
    int 21h
    
    mov dl, dh
    mov ah, 02h
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET timing           ; Prompts time message
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, ch                      ; Gets hour in ch
    aam 
    mov bx, ax
    call showTime
    
    mov dl, ':'                     ; Separates hour and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, cl                      ; Gets minute in ch
    aam 
    mov bx, ax
    call showTime                   ; Call procedure
    
    mov dl, ':'                     ; Separates second and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Gets seconds
    int 21h
    mov al, dh
    aam
    mov bx, ax
    call showTime
    
    mov ah, 09h
    mov dx, OFFSET leaveNote
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET anyKeyPrompt
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
    
    mov al, stockTwo
    mov bl, quantity
    sub al, bl
    mov stockTwo, al
    
    mov al, earnings
    mov bl, total
    add al, bl
    mov earnings, al
    
    mov ah, 01h
    int 21h
    
    jmp Menu
    
choiceThree:
    
    mov ah, 09h
    mov dx, OFFSET selection
    int 21h
    mov ah, 09h
    mov dx, OFFSET pastry
    int 21h
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h

    mov ah, 09h
    mov dx, OFFSET stock                 ; Displays available amount of meals
    int 21h
    
    mov al, stockThree                   ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov al, priceThree                   ; Prints the price of the item
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h

    mov dx, OFFSET promptQuantity        ; Prints Quantity: 
    mov ah, 09h
    int 21h

    mov ah,01h                           ; Reads Quantity
    int 21h
    sub al, 48
    mov quantity,al
    
    mov ah, 09h
    mov dx, OFFSET promptPayment
    int 21h
    
    mov al, priceThree                  ; This operation is used to calculate the total
    mul quantity                        ; The total is quantity x price
    mov total, al
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h  
    
    mov ah, 09h
    mov dx, OFFSET payPrompt        ; Prints price
    int 21h  
    
    mov bh, 0
    mov bl, 10d
    
scanch3:                            ; Reads a single digit
    mov ah, 01h
    int 21h
    cmp al, 13d                     ; if user presses Enter it stops reading
    jne storech3                    ; otherwise, it keeps reading
    jmp stopReading3
    
storech3:                           ; Stores each character after reading
    sub al, 30h
    mov cl, al
    mov al, bh
    mul bl
    add al, cl
    mov bh, al
    mov paid, al  
    
    jmp scanch3                     ; Goes back to reading a character after storing the previous character (Recursion)
    
stopReading3:
    mov al, paid                    ; Moving paid variable into variable for comparison
    mov bl, total                   ; Moving total variable into variable for comparison
    
    cmp al, bl
    jae validPayment3 
    
    cmp al, bl
    jnae invalidPayment
    
validPayment3:
    sub al, bl                      ; Subtract the total from paid amount to get the remaining amount
    
    mov ah, 09h    
    mov dx, OFFSET remaining        ; prints the remaining message
    int 21h
    
    aam
    add ax, 3030h
    
    mov dh, al
    mov dl, ah
    mov ah, 02h
    int 21h
    
    mov dl, dh
    mov ah, 02h
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET timing           ; Prompts time message
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, ch                      ; Gets hour in ch
    aam 
    mov bx, ax
    call showTime
    
    mov dl, ':'                     ; Separates hour and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, cl                      ; Gets minute in ch
    aam 
    mov bx, ax
    call showTime                   ; Call procedure
    
    mov dl, ':'                     ; Separates second and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Gets seconds
    int 21h
    mov al, dh
    aam
    mov bx, ax
    call showTime
    
    mov ah, 09h
    mov dx, OFFSET leaveNote
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET anyKeyPrompt
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
    
    mov al, stockThree
    mov bl, quantity
    sub al, bl
    mov stockThree, al
    
    mov al, earnings
    mov bl, total
    add al, bl
    mov earnings, al
    
    mov ah, 01h
    int 21h
    
    jmp Menu
    
choiceFour:
    
    mov ah, 09h
    mov dx, OFFSET selection
    int 21h
    mov ah, 09h
    mov dx, OFFSET drink
    int 21h
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h

    mov ah, 09h
    mov dx, OFFSET stock                 ; Displays available amount of meals
    int 21h
    
    mov al, stockFour                    ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov al, priceFour                    ; Prints the price of the item
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h

    mov dx, OFFSET promptQuantity        ; Prints Quantity: 
    mov ah, 09h
    int 21h

    mov ah,01h                           ; Reads Quantity
    int 21h
    sub al, 48
    mov quantity,al
    
    mov ah, 09h
    mov dx, OFFSET promptPayment
    int 21h
    
    mov al, priceFour                   ; This operation is used to calculate the total
    mul quantity                        ; The total is quantity x price
    mov total, al
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h  
    
    mov ah, 09h
    mov dx, OFFSET payPrompt        ; Prints price
    int 21h  
    
    mov bh, 0
    mov bl, 10d
    
scanch4:                            ; Reads a single digit
    mov ah, 01h
    int 21h
    cmp al, 13d                     ; if user presses Enter it stops reading
    jne storech4                    ; otherwise, it keeps reading
    jmp stopReading4
    
storech4:                           ; Stores each character after reading
    sub al, 30h
    mov cl, al
    mov al, bh
    mul bl
    add al, cl
    mov bh, al
    mov paid, al  
    
    jmp scanch4                     ; Goes back to reading a character after storing the previous character (Recursion)
    
stopReading4:
    mov al, paid                    ; Moving paid variable into variable for comparison
    mov bl, total                   ; Moving total variable into variable for comparison
    
    cmp al, bl
    jae validPayment4 
    
    cmp al, bl
    jnae invalidPayment
    
validPayment4:
    sub al, bl                      ; Subtract the total from paid amount to get the remaining amount
    
    mov ah, 09h    
    mov dx, OFFSET remaining        ; prints the remaining message
    int 21h
    
    aam
    add ax, 3030h
    
    mov dh, al
    mov dl, ah
    mov ah, 02h
    int 21h
    
    mov dl, dh
    mov ah, 02h
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET timing           ; Prompts time message
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, ch                      ; Gets hour in ch
    aam 
    mov bx, ax
    call showTime
    
    mov dl, ':'                     ; Separates hour and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Get time from system
    int 21h
    mov al, cl                      ; Gets minute in ch
    aam 
    mov bx, ax
    call showTime                   ; Call procedure
    
    mov dl, ':'                     ; Separates second and minute
    mov ah, 02h
    int 21h
    
    mov ah, 2ch                     ; Gets seconds
    int 21h
    mov al, dh
    aam
    mov bx, ax
    call showTime
    
    mov ah, 09h
    mov dx, OFFSET leaveNote
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET anyKeyPrompt
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
    
    mov al, stockFour
    mov bl, quantity
    sub al, bl
    mov stockFour, al
    
    mov al, earnings
    mov bl, total
    add al, bl
    mov earnings, al
    
    mov ah, 01h
    int 21h
    
    jmp Menu
   
choiceFive:

    mov ah, 09h
    mov dx, OFFSET statistics
    int 21h

    mov ah, 09h
    mov dx, OFFSET astespace
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET mealOne
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET stockCheck
    int 21h

    mov al, stockOne                     ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET astespace
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET mealTwo
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET stockCheck
    int 21h
    
    mov al, stockTwo                     ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET astespace
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET Pastry
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET stockCheck
    int 21h
    
    mov al, stockThree                   ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET newline               ; goes to next line
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET astespace
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET drink
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET stockCheck
    int 21h
    
    mov al, stockFour                    ; Prints the available stock
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET newline
    int 21h
    
    mov ah, 09h
    mov dx, OFFSET earningsPrompt
    int 21h
    
    mov al, earnings                    ; Prints the total Earnings
    mov bl, 0
    add al, bl   
    aam
    add ax, 3030h
    mov dh,al
    mov dl,ah
    mov ah,2
    int 21h
    mov dl,dh
    mov ah,2
    int 21h
    
    mov ah, 09h    
    mov dx, OFFSET anyKeyPrompt          ;Press anything to continue
    int 21h
    
    mov ah, 01h
    int 21h
    
    jmp Menu
    
exit:
    mov ah,4ch
    int 21h
    
    
showTime PROC                            ; Procedure to take time from system
    mov dl, bh                           ; this is the bh part of bx
    add dl, 30h
    mov ah, 02h
    int 21h
    mov dl, bl                           ; this is the bl part of bx
    add dl, 30h
    mov ah, 02h
    int 21h
    ret
showTime ENDP

END MAIN