%include "asm_io.inc"

section .data
    prompt db "Please enter 15 integers separated by spaces or newlines: ", 0
    reading db "Reading integers...", 10, 0
    sorting db "Sorting the array...", 10, 0
    sorted_array_msg db "Sorted array: ", 10, 0
    newline db 10, 0
    array resd 15
    array_size dd 15
    partitioning db "Partitioning the array...", 10, 0
    left_partition db "Sorting left partition...", 10, 0
    right_partition db "Sorting right partition...", 10, 0

section .bss
    buffer resb 2000

section .text
    extern read_int, print_int, print_string
    global asm_main, asm_quick_sort

asm_main:
    enter 0, 0
    pusha
    mov eax, prompt
    call print_string

    mov esi, array
    mov ecx, [array_size]

input_loop:
    cmp ecx, 0
    je done_input

    call read_int
    mov [esi], eax

    add esi, 4
    dec ecx
    jmp input_loop

done_input:
    mov eax, sorting
    call print_string

    mov esi, array
    mov ecx, [array_size]
    dec ecx
    xor ebx, ebx

    push ecx
    push ebx
    push esi
    call asm_quick_sort

    mov eax, sorted_array_msg
    call print_string

    mov esi, array
    mov ecx, [array_size]

print_loop:
    cmp ecx, 0
    je done_print

    mov eax, [esi]
    call print_int
    call print_nl

    add esi, 4
    dec ecx
    jmp print_loop

done_print:
    mov eax, 0
    leave
    ret

asm_quick_sort:
    push ebp
    mov ebp, esp

    push edi
    push esi
    push ebx

    mov eax, dword [ebp + 12]
    mov ebx, dword [ebp + 16]
    mov esi, dword [ebp + 8]

    cmp eax, ebx
    jnl quick_sort_end_sort

    mov ecx, eax
    mov edx, dword [esi + (4 * ebx)]

quick_sort_partiotion:
    cmp ecx, ebx
    jnb quick_sort_end_partiotion

    cmp edx, dword [esi + (4 * ecx)]

    jb qsort_cont_loop
    push edx

    mov edx, dword [esi + (4 * ecx)]
    mov edi, dword [esi + (4 * eax)]
    mov dword [esi + (4 * eax)], edx
    mov dword [esi + (4 * ecx)], edi

    pop edx
    add eax, 1

qsort_cont_loop:
    add ecx, 1
    jmp quick_sort_partiotion

quick_sort_end_partiotion:
    mov edx, dword [esi + (4 * eax)]
    mov edi, dword [esi + (4 * ebx)]
    mov dword [esi + (4 * ebx)], edx
    mov dword [esi + (4 * eax)], edi

    sub eax, 1
    push eax
    push dword [ebp + 12]
    push dword [ebp + 8]
    call asm_quick_sort

    add esp, 8
    pop eax
    add eax, 1
    push dword [ebp + 16]
    push eax
    push dword [ebp + 8]
    call asm_quick_sort

    add esp, 12

quick_sort_end_sort:
    pop ebx
    pop esi
    pop edi

    mov esp, ebp
    pop ebp

    ret
