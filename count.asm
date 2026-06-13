.MODEL SMALL			; Define memory model as small
.STACK 100h				; Allocate stack space of 100h bytes
.DATA					; Start of data segment
    newline DB 13, 10, '$'               ; New line for output formatting
    promptSecond DB 'Enter the second (0-9): $' 	; Prompt message for second input
    promptMinute DB 'Enter the minute (0-9): $' 	; Prompt message for minute input
    promptHour DB 'Enter the hour (0-9): $'			; Prompt message for hour input
    clockStoppedMsg DB 'Clock has stopped at your time.$'		; Message displayed when the clock stops
    
    ; Variables to store current time in tens and units places
    currentHourTens DB 0			; Store tens place of current hour
    currentHourUnits DB ?			; Store units place of current hour
    currentMinuteTens DB 0			; Store tens place of current minute
    currentMinuteUnits DB ?			; Store units place of current minute
    currentSecondTens DB 0			; Store tens place of current second
    currentSecondUnits DB ? 		; Store units place of current second

    ; Variables to store starting time
    startHourTens DB 0			; Store tens place of start hour
    startHourUnits DB ?			; Store units place of start hour
    startMinuteTens DB 0		; Store tens place of start minute
    startMinuteUnits DB ?		; Store units place of start minute
    startSecondTens DB 0		; Store tens place of start second
    startSecondUnits DB ?		; Store units place of start second

.CODE				; Start of code segment
MAIN PROC			; Main procedure
    ; Initialize data segment (setup data segment register)
    MOV AX, @DATA		; Load address of data segment into AX register
    MOV DS, AX			; Set DS (data segment) to the value in AX
    
    ; Get user input for starting time (second, minute, hour)
GET_SECOND_INPUT:
    MOV DX, OFFSET promptSecond        ; Load address of promptSecond message into DX
    MOV AH, 09h					; AH = 09h is DOS function for printing string
    INT 21h				; Call interrupt to display promptSecond
    CALL GET_DIGIT_INPUT               ; Call function to get digit input
    MOV currentSecondUnits, AL         ; Store the entered second value into currentSecondUnits
    MOV startSecondUnits, AL           ; Store the entered second value into currentSecondUnits

GET_MINUTE_INPUT:
    MOV DX, OFFSET newline			; Load address of newline into DX
    MOV AH, 09h						; AH = 09h is DOS function for printing string
    INT 21h							; Call interrupt to display newline

    MOV DX, OFFSET promptMinute       ; Load address of promptMinute message into DX
    MOV AH, 09h						; AH = 09h is DOS function for printing string
    INT 21h						; Call interrupt to display newline
    CALL GET_DIGIT_INPUT               ; Call function to get digit input
    MOV currentMinuteUnits, AL         ; Store the entered minute value into currentMinuteUnits
    MOV startMinuteUnits, AL           ; Store the entered minute value into startMinuteUnits

GET_HOUR_INPUT:
    MOV DX, OFFSET newline			; Load address of newline into DX
    MOV AH, 09h					; AH = 09h for printing string
    INT 21h						; Call interrupt to display newline

    MOV DX, OFFSET promptHour         ; Load address of promptHour message into DX
    MOV AH, 09h						; AH = 09h for printing string
    INT 21h							; Call interrupt to display promptHour
    CALL GET_DIGIT_INPUT               ; Call function to get digit input
    MOV currentHourUnits, AL           ; Store the entered hour value into currentHourUnits
    MOV startHourUnits, AL             ; Store the entered hour value into startHourUnits

    ; Display initial newline after getting inputs
    MOV DX, OFFSET newline				; Load address of newline into DX
    MOV AH, 09h					; AH = 09h for printing string
    INT 21h					; Call interrupt to display newline

START_CLOCK:
    CALL DISPLAY_CURRENT_TIME          ; Call function to display current time
    CALL UPDATE_TIME                   ; Call function to update the time based on logic
    
    ; Check if we've reached starting time again (to stop clock)
    CALL CHECK_STOP_CONDITION
    CMP AL, 1							; Compare AL with 1 to check if stop condition is met
    JE STOP_CLOCK                      ; If AL is 1, jump to STOP_CLOCK (halt the clock)

    ; Add delay for clock visualization
    CALL SHORT_DELAY					; Call function to add delay for visual effect
    JMP START_CLOCK                    ; Loop back to start clock until stop condition is met

STOP_CLOCK:
    ; Display final stop message indicating the clock stopped at input time
    MOV DX, OFFSET newline			; Load address of newline into DX
    MOV AH, 09h						; AH = 09h for printing string
    INT 21h							; Call interrupt to display newline
    MOV DX, OFFSET clockStoppedMsg		; Load address of clockStoppedMsg into DX
    MOV AH, 09h							; AH = 09h for printing string
    INT 21h					; Call interrupt to display clockStoppedMsg

    ; End program and return control to the operating system
    MOV AH, 4Ch				; AH = 4Ch for terminating program
    INT 21h					; Call interrupt to terminate program
MAIN ENDP				; End of main procedure

; Function to get a single digit input from the user
GET_DIGIT_INPUT PROC
    MOV AH, 01h                      ; AH = 01h is DOS function to read a single character from input
    INT 21h                           ; Call interrupt to get character from user input
    SUB AL, '0'                       ; Convert ASCII character to integer (subtract '0' to get actual digit)
    RET					; Return from function
GET_DIGIT_INPUT ENDP

; Function to display current time in hh:mm:ss format
DISPLAY_CURRENT_TIME PROC
    ; Display hours (tens place)
    MOV DL, currentHourTens			; Load tens place of hours into DL
    ADD DL, '0'                     ; Convert digit to ASCII by adding '0'
    MOV AH, 02h						; AH = 02h for printing single character
    INT 21h                         ; Call interrupt to print hour tens place

    ; Display hours (units place)
    MOV DL, currentHourUnits			; Load units place of hours into DL
    ADD DL, '0'                       ; Convert digit to ASCII by adding '0'
    MOV AH, 02h						; AH = 02h for printing single character
    INT 21h						; Call interrupt to print hour units place

    ; Display first colon separator
    MOV DL, ':' 			; Load ':' into DL
    MOV AH, 02h				; AH = 02h for printing single character
    INT 21h					; Call interrupt to print colon separator

    ; Display minutes (tens place)
    MOV DL, currentMinuteTens			; Load tens place of minutes into DL
    ADD DL, '0'                       ; Convert digit to ASCII by adding '0'
    MOV AH, 02h						; AH = 02h for printing single character
    INT 21h						; Call interrupt to print minute tens place

    ; Display minutes (units place)
    MOV DL, currentMinuteUnits		; Load units place of minutes into DL
    ADD DL, '0'                     ; Convert digit to ASCII by adding '0'
    MOV AH, 02h						; AH = 02h for printing single character
    INT 21h							; Call interrupt to print minute units place

    ; Display second colon separator
    MOV DL, ':'						; Load ':' into DL
    MOV AH, 02h						; AH = 02h for printing single character
    INT 21h							; Call interrupt to print colon separator

    ; Display seconds (tens place)
    MOV DL, currentSecondTens			; Load tens place of seconds into DL
    ADD DL, '0'                         ; Convert digit to ASCII by adding '0'
    MOV AH, 02h							; AH = 02h for printing single character
    INT 21h								; Call interrupt to print second tens place

    ; Display seconds (units place)
    MOV DL, currentSecondUnits			; Load units place of seconds into DL
    ADD DL, '0'                       ; Convert digit to ASCII by adding '0'
    MOV AH, 02h							; AH = 02h for printing single character
    INT 21h								; Call interrupt to print second units place

    ; New line after displaying time
    MOV DX, OFFSET newline				; Load address of newline into DX
    MOV AH, 09h							; AH = 09h for printing string
    INT 21h								; Call interrupt to display newline

    RET							; Return from function
DISPLAY_CURRENT_TIME ENDP

; Function to update the time by incrementing seconds, minutes, and hours
UPDATE_TIME PROC
    ; Increment seconds and check for carry
    INC currentSecondUnits				; Increment units place of seconds
    CMP currentSecondUnits, 10			; Compare if units place is 10
    JNE NO_SECOND_CARRY               ; If no carry, continue
    MOV currentSecondUnits, 0         ; Reset units place of seconds to 0
    INC currentSecondTens             ; Increment tens place of seconds

NO_SECOND_CARRY:
    CMP currentSecondTens, 6			; If tens place of seconds is 6, increment minutes
    JNE NO_MINUTE_CARRY              ; If not 6, skip carry check
    MOV currentSecondTens, 0         ; Reset tens place of seconds to 0
    INC currentMinuteUnits           ; Increment minutes units

NO_MINUTE_CARRY:
    CMP currentMinuteUnits, 10			; Compare if units place of minutes is 10
    JNE CHECK_MINUTE_TENS            	; If not 10, skip carry check
    MOV currentMinuteUnits, 0       	; Reset units place of minutes to 0
    INC currentMinuteTens           	; Increment tens place of minutes

CHECK_MINUTE_TENS:
    CMP currentMinuteTens, 6			; If tens place of minutes is 6, increment hour
    JNE NO_HOUR_CARRY                ; If not 6, skip carry check
    MOV currentMinuteTens, 0         ; Reset tens place of minutes to 0
    INC currentHourUnits             ; Increment units place of hours

NO_HOUR_CARRY:
    CMP currentHourUnits, 10			; Compare if units place of hours is 10
    JNE CHECK_HOUR_RESET             ; If not 10, skip carry check
    MOV currentHourUnits, 0          ; Reset units place of hours to 0
    INC currentHourTens              ; Increment tens place of hours

CHECK_HOUR_RESET:
    ; Reset time to 00:00:00 if it reaches 12:00:00
    CMP currentHourTens, 1
    JNE TIME_UPDATED
    CMP currentHourUnits, 2
    JNE TIME_UPDATED

    MOV currentHourTens, 0           ; Reset hours
    MOV currentHourUnits, 0
    MOV currentMinuteTens, 0         ; Reset minutes
    MOV currentMinuteUnits, 0
    MOV currentSecondTens, 0         ; Reset seconds
    MOV currentSecondUnits, 0

TIME_UPDATED:
    RET				; Return from function
UPDATE_TIME ENDP

; Function to check if the current time has reached the start time
CHECK_STOP_CONDITION PROC
    ; Compare current time with start time
    MOV AL, currentHourTens
    CMP AL, startHourTens
    JNE NOT_STOPPED			; If hour tens don't match, skip check

    MOV AL, currentHourUnits
    CMP AL, startHourUnits
    JNE NOT_STOPPED			; If hour units don't match, skip check

    MOV AL, currentMinuteTens
    CMP AL, startMinuteTens
    JNE NOT_STOPPED			; If minute tens don't match, skip check

    MOV AL, currentMinuteUnits
    CMP AL, startMinuteUnits
    JNE NOT_STOPPED			; If minute units don't match, skip check

    MOV AL, currentSecondTens
    CMP AL, startSecondTens
    JNE NOT_STOPPED			; If second tens don't match, skip check

    MOV AL, currentSecondUnits
    CMP AL, startSecondUnits
    JNE NOT_STOPPED			; If second units don't match, skip check

    MOV AL, 1  ; Set AL to 1 indicating stop condition is met
    RET

NOT_STOPPED:
    MOV AL, 0  ; Continue running
    RET			; Return from function
CHECK_STOP_CONDITION ENDP

; Function to add a small delay to slow down the clock visualization
SHORT_DELAY PROC
    MOV CX, 10							;Delay time
DELAY_LOOP:
    NOP                                ; No operation (just wait)
    LOOP DELAY_LOOP
    RET				; Return from function
SHORT_DELAY ENDP

END MAIN

