extern unsigned char uart_tx;

void main(void){
    while(1){
        for(int c = 0; c < 27; ++c){
            uart_tx = 'a' + c;
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