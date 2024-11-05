.data
input_filename: .asciiz "raw_input.txt" 
output_filename: .asciiz "formatted_result.txt"
buffer: .space 300
msg: .asciiz "Read file: "
newline: .asciiz "\n"
output_header: .asciiz "--Student personal information--\n"
name_label: .asciiz "Name: "
id_label: .asciiz "ID: "
address_label: .asciiz "Address: "
age_label: .asciiz "Age: "
religion_label: .asciiz "Religion: "
name: .space 32                             
id: .space 32                               
address: .space 64                          
age: .space 8                               
religion: .space 8                               
.text
main:
    # Open file
    li $v0, 13                             
    la $a0, input_filename                       
    li $a1, 0                              
    li $a2, 0                              
    syscall

    move $a0, $v0
    li $v0, 14                             
    la $a1, buffer                         
    li $a2, 300                            
    syscall                                

    la $t1, buffer                         
    la $t2, name                            
    li $t7, 0                               

read_procedure:
    lb $t8, 0($t1) # Read the current character
    beqz $t8, end_read # if the current character is null
    beq $t8, ',', store_procedure # if the current character is ','
    sb $t8, 0($t2)
    addi $t2, $t2, 1
    j next
store_procedure:
    sb $zero, 0($t2)
    addi $t7, $t7, 1
    beq $t7, 1, store_id
    beq $t7, 2, store_address
    beq $t7, 3, store_age
    beq $t7, 4, store_religion
    j next
store_id:
    la $t2, id
    j next
store_address:
    la $t2, address
    j next
store_age:
    la $t2, age
    j next
store_religion:
    la $t2, religion
    j next  
next:
    addi $t1, $t1, 1
    j read_procedure
end_read:

    sb $zero, 0($t2)
    # In thông tin cá nhân
    la $a0, output_header                              
    li $v0, 4                               
    syscall
    # Print "Name: "
    la $a0, name_label                            
    li $v0, 4
    syscall
    # Print name
    la $a0, name                        
    li $v0, 4
    syscall
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    # Print "ID: "
    la $a0, id_label                             
    li $v0, 4
    syscall
    # Print id
    la $a0, id                             
    li $v0, 4
    syscall
    # Print newline
    la $a0, newline                              
    li $v0, 4
    syscall
    # Print "Address: "
    la $a0, address_label                              
    li $v0, 4
    syscall
    # Print address
    la $a0, address                         
    li $v0, 4
    syscall
    # Print newline
    la $a0, newline                              
    li $v0, 4
    syscall
    # Print "Age: "
    la $a0, age_label                               
    li $v0, 4
    syscall
    # Print age
    la $a0, age                             
    li $v0, 4
    syscall
    # Print newline
    la $a0, newline                            
    li $v0, 4
    syscall
    # Print "Religion "
    la $a0, religion_label
    li $v0, 4
    syscall
    # Print religion
    la $a0, religion                        
    li $v0, 4
    syscall
    # Write file
    li $v0, 13                      
    la $a0, output_filename                 
    li $a1, 1                        
    li $a2, 0                        
    syscall                          
    move $t0, $v0
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, output_header                  
    li $a2, 34                       
    syscall
    # Write name
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, name_label                     
    li $a2, 6                       
    syscall                         
    li $v0, 15                      
    move $a0, $t0                    
    la $a1, name                     
    li $a2, 32                       
    syscall            
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, newline                    
    li $a2, 1                       
    syscall            
    # Write id
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, id_label                     
    li $a2, 3                       
    syscall                          
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, id                     
    li $a2, 32                       
    syscall    
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, newline                    
    li $a2, 1                       
    syscall                    
    # Write address
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, address_label                     
    li $a2, 9                       
    syscall                          
    li $v0, 15                       
    move $a0, $t0                    
    la $a1,address                    
    li $a2, 64                       
    syscall       
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, newline                     
    li $a2, 1                       
    syscall                 
    # Write age
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, age_label                     
    li $a2, 5                       
    syscall                          
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, age                     
    li $a2, 8                       
    syscall        
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, newline                     
    li $a2, 1                       
    syscall                
    # Write religion
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, religion_label                     
    li $a2, 10                       
    syscall                          
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, religion                   
    li $a2, 8                       
    syscall
    li $v0, 15                       
    move $a0, $t0                    
    la $a1, newline                     
    li $a2, 1                       
    syscall                        
