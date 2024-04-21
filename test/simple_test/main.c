#include <stdint.h>

extern volatile unsigned char uart_tx;

typedef struct{
    volatile uint8_t a;
    volatile uint16_t miss_aligned_u16;
} S;

void main(void){
    volatile S s;
    while(1){
        for(int c = 0; c < 27; ++c){
            uart_tx = 'a' + c + s.a + s.miss_aligned_u16;
            uart_tx = (unsigned char)&s.miss_aligned_u16;
            
            for(volatile int i = 0; i < 1000; ++i){
                __asm__ volatile(
                    "nop;"
                    :
                    :
                    :
                );
            } // wait
        }
    }
}
