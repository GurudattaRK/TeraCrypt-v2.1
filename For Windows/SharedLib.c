#include <strings.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define block 128

unsigned int row[32],column[32],keys[32];
int main(int id,unsigned long long int rounds,int mode,char * buffer,char * keybuffer) 
{
    
    char* rowbuf = buffer;
    char* colbuf = buffer;

    memcpy(keys,keybuffer,128);


    if(mode==0) //ENCRYPTION
    {

        for(unsigned long long int i=0;i<rounds;i++)
        {
            //encryption stuff starts here
            
            //core starts here
            asm(    
                "pushfq\n\t"   // Push EFLAGS register
                "pushq %%rax\n\t"
                "pushq %%rbx\n\t"
                "pushq %%rcx\n\t"
                "pushq %%rdx\n\t"
                "pushq %%rsi\n\t"
                "pushq %%rdi\n\t"
                "pushq %%rbp\n\t"
                "pushq %%rsp\n\t"
                "pushq %%r8\n\t"
                "pushq %%r9\n\t"
                "pushq %%r10\n\t"
                "pushq %%r11\n\t"
                "pushq %%r12\n\t"
                "pushq %%r13\n\t"
                "pushq %%r14\n\t"
                "pushq %%r15\n\t"

                "xorq    %%r11,%%r11\n\t"                   //initialize i(r4) as zero
                "leaq    keys(%%rip),%%r13\n\t"             //move key array's starting address into r15
                "movq    %[rowbuf],%%r14\n\t"               //move row array's starting address into rdx
                "leaq    column(%%rip),%%r15\n"             //move column array's starting address into r14

                //ROUND STARTS HERE
                ".Round%=:\n\t"
                "movl    (%%r13,%%r11,4),%%ecx\n\t"         //move first key from key array's starting address into ecx

                //rotating Rows of 32x32 matrix
                "xorq    %%r8,%%r8\n"                       //initialize r8 as zero

                ".RowJump%=:\n\t"
                    
                    "movl    (%%r14,%%r8,4),%%eax\n\t"      // move first row into eax
                    "rorl    %%cl,%%eax\n\t"                // rotate row in rax by "cl" bits towards RIGHT
                    "rorq    $7,%%rcx\n\t"                  // update key
                    "movl    %%eax,(%%r14,%%r8,4)\n\t"      // move row back to the address pointed by r14
                    "incl    %%r8d\n\t"                     // increment address to point to next row

                    "movl    (%%r14,%%r8,4),%%eax\n\t"      // move next row into rax
                    "roll    %%cl,%%eax\n\t"                // rotate row in rax by "cl" bits towards LEFT
                    "rorq    $3,%%rcx\n\t"                  // update key
                    "movl    %%eax,(%%r14,%%r8,4)\n\t"      // move row back to the address pointed by r14
                    "incl    %%r8d\n\t"                     // increment address to point to next row

                    "cmp     $32,%%r8\n\t"                  // check if all rows have rotated or not
                    "jne    .RowJump%=\n\t"                 // if not then loop back
                    

                "xorq    %%r9,%%r9\n\t"

                // bitwise operations
                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14)\n\t"                // XOR one row with one key

                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14,%%r11,4)\n\t"        // XOR one row with one key

                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14,%%r11,4)\n\t"        // XOR one row with one key


                // convert rows to columns

                ".RowOuter%=:\n\t"

                    "xorq    %%r8,%%r8\n"
                    ".RowInner%=:\n\t"

                        "bt      %%r9d,(%%r14,%%r8,4)\n\t"
                        "jnc    .RowReset%=\n\t"               
                        "bts     %%r8d,%%r10d\n\t"
                        "jmp    .RowExit%=\n"

                        ".RowReset%=:\n\t"
                        "btr     %%r8d,%%r10d\n"

                    ".RowExit%=:\n\t"
                    "incl    %%r8d\n\t"
                    "cmp     $32,%%r8d\n\t"                 // check condition....
                    "jne    .RowInner%=\n\t"                // if not true loop back to .Inner
                    "movl    %%r10d,(%%r15,%%r9,4)\n\t"
                    "incq    %%r9\n\t"
                    "cmp     $32,%%r9\n\t"                  //check condition....
                    "jne    .RowOuter%=\n\t"                // if not true loop back to .Outer

                // rotating Columns of the 32x32 matrix
                "xorq    %%r8,%%r8\n"                       // Everything from here onwards is same as code above which 
                "incl    %%r11d\n\t"                        // processed rows but here columns are processed
                "movl    (%%r13,%%r11,4),%%ecx\n\t"           
                
                ".ColJump%=:\n\t"

                    "movl    (%%r15,%%r8,4),%%eax\n\t"        
                    "rorl    %%cl,%%eax\n\t"                  
                    "rorq    $9,%%rcx\n\t"                    
                    "movl    %%eax,(%%r15,%%r8,4)\n\t"        
                    "incl    %%r8d\n\t"                        
                    "movl    (%%r15,%%r8,4),%%eax\n\t"        
                    "roll    %%cl,%%eax\n\t"                  
                    "rorq    $11,%%rcx\n\t"
                    "movl    %%eax,(%%r15,%%r8,4)\n\t"
                    "incl    %%r8d\n\t"

                    "cmp     $32,%%r8\n\t"                        
                    "jne    .ColJump%=\n\t"                       

                // bitwise operations
                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15)\n\t"         
                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15,%%r11,4)\n\t"         
                "incl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15,%%r11,4)\n\t"         

                "incl    %%r11d\n\t"                        
                "cmp     $32,%%r11\n\t"                       
                "je     .ExitRound%=\n\t"                        

                // Convert columns to row
                "xorq    %%r9,%%r9\n"
                ".ColOuter%=:\n\t"

                    "xorq    %%r8,%%r8\n"
                    ".ColInner%=:\n\t"

                        "bt      %%r9,(%%r15,%%r8,4)\n\t"
                        "jnc    .ColReset%=\n\t"               
                        "bts     %%r8d,%%r10d\n\t"
                        "jmp    .ColExit%=\n"

                        ".ColReset%=:\n\t"
                        "btr     %%r8d,%%r10d\n"

                    ".ColExit%=:\n\t"
                    "incl    %%r8d\n\t"
                    "cmp     $32,%%r8d\n\t"                 //check condition....
                    "jne    .ColInner%=\n\t"                // if not true loop back to .Inner
                    "movl    %%r10d,(%%r14,%%r9,4)\n\t"
                    "incq    %%r9\n\t"
                    "cmp     $32,%%r9\n\t"                  //check condition....
                    "jne    .ColOuter%=\n\t"                // if not true loop back to .Outer
                    
                "jmp    .Round%=\n"                         // keep looping until all keys in key array are used
                ".ExitRound%=:\n\t"                         // if all keys are used exit from here

                "popq %%r15\n\t"
                "popq %%r14\n\t"
                "popq %%r13\n\t"
                "popq %%r12\n\t"
                "popq %%r11\n\t"
                "popq %%r10\n\t"
                "popq %%r9\n\t"
                "popq %%r8\n\t"
                "popq %%rsp\n\t"
                "popq %%rbp\n\t"
                "popq %%rdi\n\t"
                "popq %%rsi\n\t"
                "popq %%rdx\n\t"
                "popq %%rcx\n\t"
                "popq %%rbx\n\t"
                "popq %%rax\n\t"
                "popfq\n\t"   // Pop EFLAGS register

                : [rowbuf] "=m" (rowbuf)
                : "m" (rowbuf)
                : "cc"
            );
            //core ends here

            memmove(colbuf,column,128);
            colbuf = colbuf +128;
            rowbuf = rowbuf +128;

            //encryption stuff ends here/
        }
        
       

    }
    else if(mode>0 || mode!=0)  //DECRYPTION
    {

        for(unsigned long long int i=0;i<rounds;i++)
        {
            //encryption stuff starts here/
            //core starts here

            // core starts here
            asm(    

                "pushfq\n\t"   // Push EFLAGS register
                "pushq %%rax\n\t"
                "pushq %%rbx\n\t"
                "pushq %%rcx\n\t"
                "pushq %%rdx\n\t"
                "pushq %%rsi\n\t"
                "pushq %%rdi\n\t"
                "pushq %%rbp\n\t"
                "pushq %%rsp\n\t"
                "pushq %%r8\n\t"
                "pushq %%r9\n\t"
                "pushq %%r10\n\t"
                "pushq %%r11\n\t"
                "pushq %%r12\n\t"
                "pushq %%r13\n\t"
                "pushq %%r14\n\t"
                "pushq %%r15\n\t"

                "movq    $32,%%r11\n\t"                     //initialize i(r4) as zero
                "leaq    keys(%%rip),%%r13\n\t"               //move key array's starting address into r15
                "leaq    row(%%rip),%%r14\n\t"                //move row array's starting address into rdx
                "movq    %[colbuf],%%r15\n"               //move column array's starting address into r14

                //ROUND STARTS HERE

                ".Round%=:\n\t"
                // bitwise operations

                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15,%%r11,4)\n\t"
            
                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15,%%r11,4)\n\t"
                
                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r15)\n\t"
                
                //shifitng in columns
                
                "xorq    %%r8,%%r8\n"                       
                "decl    %%r11d\n\t"
                    
                "movl    (%%r13,%%r11,4),%%ecx\n\t"             
                
                ".ColJump%=:\n\t"

                    "movl    (%%r15,%%r8,4),%%eax\n\t"        
                    "roll    %%cl,%%eax\n\t"                  
                    "rorq    $9,%%rcx\n\t"                    
                    "movl    %%eax,(%%r15,%%r8,4)\n\t"        
                    "incl    %%r8d\n\t"                        
                    "movl    (%%r15,%%r8,4),%%eax\n\t"        
                    "rorl    %%cl,%%eax\n\t"                  
                    "rorq    $11,%%rcx\n\t"
                    "movl    %%eax,(%%r15,%%r8,4)\n\t"
                    "incl    %%r8d\n\t"
                    
                "cmp     $32,%%r8\n\t"   
                "jne    .ColJump%=\n\t"



                //columns to rows
                "xorq    %%r9,%%r9\n"
                ".ColOuter%=:\n\t"

                    "xorq    %%r8,%%r8\n"
                    ".ColInner%=:\n\t"

                        "bt      %%r9,(%%r15,%%r8,4)\n\t"
                        "jnc    .ColReset%=\n\t"               
                        "bts     %%r8d,%%r10d\n\t"
                        "jmp    .ColExit%=\n"

                        ".ColReset%=:\n\t"
                        "btr     %%r8d,%%r10d\n"

                    ".ColExit%=:\n\t"
                    "incl    %%r8d\n\t"
                    "cmp     $32,%%r8\n\t"
                    "jne    .ColInner%=\n\t"
                    "movl    %%r10d,(%%r14,%%r9,4)\n\t"
                    "incq    %%r9\n\t"
                    "cmp     $32,%%r9\n\t"
                    "jne    .ColOuter%=\n\t"                  // if not true loop back to .Outer


                //// bitwise operations

                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14,%%r11,4)\n\t"
            
                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14,%%r11,4)\n\t"
                
                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%r12d\n\t"
                "xorl    %%r12d,(%%r14)\n\t"


                ////shifting in rows
                "xorq    %%r8,%%r8\n"                       
                "decl    %%r11d\n\t"
                "movl    (%%r13,%%r11,4),%%ecx\n\t"             

                ".RowJump%=:\n\t"

                    "movl    (%%r14,%%r8,4),%%eax\n\t"        
                    "roll    %%cl,%%eax\n\t"                  
                    "rorq    $7,%%rcx\n\t"                    
                    "movl    %%eax,(%%r14,%%r8,4)\n\t"        
                    "incl    %%r8d\n\t"                        

                    "movl    (%%r14,%%r8,4),%%eax\n\t"        
                    "rorl    %%cl,%%eax\n\t"                  
                    "rorq    $3,%%rcx\n\t"
                    "movl    %%eax,(%%r14,%%r8,4)\n\t"
                    "incl    %%r8d\n\t"


                "cmp     $32,%%r8\n\t"    
                "jne    .RowJump%=\n\t"

                "xorq    %%r9,%%r9\n\t"

                "cmp     $0,%%r11\n\t"   
                "jle     .ExitRound%=\n\t"
                // rows to columns

                ".RowOuter%=:\n\t"

                    "xorq    %%r8,%%r8\n"
                    ".RowInner%=:\n\t"

                        "bt      %%r9d,(%%r14,%%r8,4)\n\t"
                        "jnc    .RowReset%=\n\t"               
                        "bts     %%r8d,%%r10d\n\t"
                        "jmp    .RowExit%=\n"

                        ".RowReset%=:\n\t"
                        "btr     %%r8d,%%r10d\n"

                    ".RowExit%=:\n\t"
                    "incl    %%r8d\n\t"
                    "cmp     $32,%%r8\n\t"
                    "jne    .RowInner%=\n\t"
                    "movl    %%r10d,(%%r15,%%r9,4)\n\t"
                    "incq    %%r9\n\t"
                    "cmp     $32,%%r9\n\t"
                    "jne    .RowOuter%=\n\t"

                "jmp    .Round%=\n"
                ".ExitRound%=:\n\t"


                "popq %%r15\n\t"
                "popq %%r14\n\t"
                "popq %%r13\n\t"
                "popq %%r12\n\t"
                "popq %%r11\n\t"
                "popq %%r10\n\t"
                "popq %%r9\n\t"
                "popq %%r8\n\t"
                "popq %%rsp\n\t"
                "popq %%rbp\n\t"
                "popq %%rdi\n\t"
                "popq %%rsi\n\t"
                "popq %%rdx\n\t"
                "popq %%rcx\n\t"
                "popq %%rbx\n\t"
                "popq %%rax\n\t"
                "popfq\n\t"   // Pop EFLAGS register

                : [colbuf] "=m" (colbuf)
                : "m" (colbuf)
                : "cc"
            );
            //core ends here
           

            memmove(rowbuf,row,128);
            colbuf = colbuf +128;
            rowbuf = rowbuf +128;

            //encryption stuff ends here/
        }
        
        
    }
    else
    {
        printf("\nidk whats wrong\n");
    }

    return 0;
}
