  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
.global  __gVectors
.global  Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

.section  .text.Reset_Handler
  .weak  Reset_Handler
  .type  Reset_Handler, %function
Reset_Handler:  

/* Copy the data segment initializers from flash to SRAM */  
  movs  r1, #0
  b  LoopCopyDataInit

CopyDataInit:
  ldr  r3, =_sidata
  ldr  r3, [r3, r1]
  str  r3, [r0, r1]
  adds  r1, r1, #4
    
LoopCopyDataInit:
  ldr  r0, =_sdata
  ldr  r3, =_edata
  adds  r2, r0, r1
  cmp  r2, r3
  bcc  CopyDataInit
  ldr  r2, =_sbss
  b  LoopFillZerobss
/* Zero fill the bss segment. */  
FillZerobss:
  movs  r3, #0
  str  r3, [r2]
  adds r2, r2, #4
    
LoopFillZerobss:
  ldr  r3, = _ebss
  cmp  r2, r3
  bcc  FillZerobss

/* call into Arduino core's low-level first-init function */
  bl first_system_init

/* Call the clock system initialization function.*/
  bl  SystemInit   
/* Call into static constructors (C++) */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl  main
  bx  lr    
.size  Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an 
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 * @param  None     
 * @retval None       
*/
    .section  .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b  Infinite_Loop
  .size  Default_Handler, .-Default_Handler
/******************************************************************************
*
* The minimal vector table for a Cortex M4. Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
* 
*******************************************************************************/
   .section  .vectors,"a",%progbits
  .type  __gVectors, %object
  .size  __gVectors, .-__gVectors

__gVectors:
                .word     _sp                            /* Top of Stack */
                .word     Reset_Handler		/* Reset Handler */
                .word     NMI_Handler		/* NMI Handler */
                .word     HardFault_Handler		/* Hard Fault Handler */
                .word     MemManage_Handler		/* MPU Fault Handler */
                .word     BusFault_Handler		/* Bus Fault Handler */
                .word     UsageFault_Handler		/* Usage Fault Handler */
                .word     0		/* Reserved */
                .word     0		/* Reserved */
                .word     0		/* Reserved */
                .word     0		/* Reserved */
                .word     SVC_Handler		/* SVCall Handler */
                .word     DebugMon_Handler		/* Debug Monitor Handler */
                .word     0		/* Reserved */
                .word     PendSV_Handler		/* PendSV Handler */
                .word     SysTick_Handler		/* SysTick Handler */
                .word     WWDGT_IRQHandler		/* 16:Window Watchdog Timer */
                .word     LVD_IRQHandler		/* 17:LVD through EXTI Line detect */
                .word     TAMPER_STAMP_IRQHandler		/* 18:Tamper and TimeStamp through EXTI Line detect */
                .word     RTC_WKUP_IRQHandler		/* 19:RTC Wakeup through EXTI Line */
                .word     FMC_IRQHandler		/* 20:FMC */
                .word     RCU_CTC_IRQHandler		/* 21:RCU and CTC */
                .word     EXTI0_IRQHandler		/* 22:EXTI Line 0 */
                .word     EXTI1_IRQHandler		/* 23:EXTI Line 1 */
                .word     EXTI2_IRQHandler		/* 24:EXTI Line 2 */
                .word     EXTI3_IRQHandler		/* 25:EXTI Line 3 */
                .word     EXTI4_IRQHandler		/* 26:EXTI Line 4 */
                .word     DMA0_Channel0_IRQHandler		/* 27:DMA0 Channel0 */
                .word     DMA0_Channel1_IRQHandler		/* 28:DMA0 Channel1 */
                .word     DMA0_Channel2_IRQHandler		/* 29:DMA0 Channel2 */
                .word     DMA0_Channel3_IRQHandler		/* 30:DMA0 Channel3 */
                .word     DMA0_Channel4_IRQHandler		/* 31:DMA0 Channel4 */
                .word     DMA0_Channel5_IRQHandler		/* 32:DMA0 Channel5 */
                .word     DMA0_Channel6_IRQHandler		/* 33:DMA0 Channel6 */
                .word     ADC_IRQHandler		/* 34:ADC */
                .word     CAN0_TX_IRQHandler		/* 35:CAN0 TX */
                .word     CAN0_RX0_IRQHandler		/* 36:CAN0 RX0 */
                .word     CAN0_RX1_IRQHandler		/* 37:CAN0 RX1 */
                .word     CAN0_EWMC_IRQHandler		/* 38:CAN0 EWMC */
                .word     EXTI5_9_IRQHandler		/* 39:EXTI5 to EXTI9 */
                .word     TIMER0_BRK_TIMER8_IRQHandler		/* 40:TIMER0 Break and TIMER8 */
                .word     TIMER0_UP_TIMER9_IRQHandler		/* 41:TIMER0 Update and TIMER9 */
                .word     TIMER0_TRG_CMT_TIMER10_IRQHandler		/* 42:TIMER0 Trigger and Commutation and TIMER10 */
                .word     TIMER0_Channel_IRQHandler		/* 43:TIMER0 Capture Compare */
                .word     TIMER1_IRQHandler		/* 44:TIMER1 */
                .word     TIMER2_IRQHandler		/* 45:TIMER2 */
                .word     TIMER3_IRQHandler		/* 46:TIMER3 */
                .word     I2C0_EV_IRQHandler		/* 47:I2C0 Event */
                .word     I2C0_ER_IRQHandler		/* 48:I2C0 Error */
                .word     I2C1_EV_IRQHandler		/* 49:I2C1 Event */
                .word     I2C1_ER_IRQHandler		/* 50:I2C1 Error */
                .word     SPI0_IRQHandler		/* 51:SPI0 */
                .word     SPI1_IRQHandler		/* 52:SPI1 */
                .word     USART0_IRQHandler		/* 53:USART0 */
                .word     USART1_IRQHandler		/* 54:USART1 */
                .word     USART2_IRQHandler		/* 55:USART2 */
                .word     EXTI10_15_IRQHandler		/* 56:EXTI10 to EXTI15 */
                .word     RTC_Alarm_IRQHandler		/* 57:RTC Alarm */
                .word     USBFS_WKUP_IRQHandler		/* 58:USBFS Wakeup */
                .word     TIMER7_BRK_TIMER11_IRQHandler		/* 59:TIMER7 Break and TIMER11 */
                .word     TIMER7_UP_TIMER12_IRQHandler		/* 60:TIMER7 Update and TIMER12 */
                .word     TIMER7_TRG_CMT_TIMER13_IRQHandler		/* 61:TIMER7 Trigger and Commutation and TIMER13 */
                .word     TIMER7_Channel_IRQHandler		/* 62:TIMER7 Channel Capture Compare */
                .word     DMA0_Channel7_IRQHandler		/* 63:DMA0 Channel7 */
                .word     EXMC_IRQHandler		/* 64:EXMC */
                .word     SDIO_IRQHandler		/* 65:SDIO */
                .word     TIMER4_IRQHandler		/* 66:TIMER4 */
                .word     SPI2_IRQHandler		/* 67:SPI2 */
                .word     UART3_IRQHandler		/* 68:UART3 */
                .word     UART4_IRQHandler		/* 69:UART4 */
                .word     TIMER5_DAC_IRQHandler		/* 70:TIMER5 and DAC0 DAC1 Underrun error */
                .word     TIMER6_IRQHandler		/* 71:TIMER6 */
                .word     DMA1_Channel0_IRQHandler		/* 72:DMA1 Channel0 */
                .word     DMA1_Channel1_IRQHandler		/* 73:DMA1 Channel1 */
                .word     DMA1_Channel2_IRQHandler		/* 74:DMA1 Channel2 */
                .word     DMA1_Channel3_IRQHandler		/* 75:DMA1 Channel3 */
                .word     DMA1_Channel4_IRQHandler		/* 76:DMA1 Channel4 */
                .word     ENET_IRQHandler		/* 77:Ethernet */
                .word     ENET_WKUP_IRQHandler		/* 78:Ethernet Wakeup through EXTI Line */
                .word     CAN1_TX_IRQHandler		/* 79:CAN1 TX */
                .word     CAN1_RX0_IRQHandler		/* 80:CAN1 RX0 */
                .word     CAN1_RX1_IRQHandler		/* 81:CAN1 RX1 */
                .word     CAN1_EWMC_IRQHandler		/* 82:CAN1 EWMC */
                .word     USBFS_IRQHandler		/* 83:USBFS */
                .word     DMA1_Channel5_IRQHandler		/* 84:DMA1 Channel5 */
                .word     DMA1_Channel6_IRQHandler		/* 85:DMA1 Channel6 */
                .word     DMA1_Channel7_IRQHandler		/* 86:DMA1 Channel7 */
                .word     USART5_IRQHandler		/* 87:USART5 */
                .word     I2C2_EV_IRQHandler		/* 88:I2C2 Event */
                .word     I2C2_ER_IRQHandler		/* 89:I2C2 Error */
                .word     USBHS_EP1_Out_IRQHandler		/* 90:USBHS Endpoint 1 Out  */
                .word     USBHS_EP1_In_IRQHandler		/* 91:USBHS Endpoint 1 in */
                .word     USBHS_WKUP_IRQHandler		/* 92:USBHS Wakeup through EXTI Line */
                .word     USBHS_IRQHandler		/* 93:USBHS */
                .word     DCI_IRQHandler		/* 94:DCI */
                .word     0		/* 95:Reserved */
                .word     TRNG_IRQHandler		/* 96:TRNG */
                .word     FPU_IRQHandler		/* 97:FPU */
                .word     UART6_IRQHandler		/* 98:UART6 */
                .word     UART7_IRQHandler		/* 99:UART7 */
                .word     SPI3_IRQHandler		/* 100:SPI3 */
                .word     SPI4_IRQHandler		/* 101:SPI4 */
                .word     SPI5_IRQHandler		/* 102:SPI5 */
                .word     0		/* 103:Reserved */
                .word     TLI_IRQHandler		/* 104:TLI */
                .word     TLI_ER_IRQHandler		/* 105:TLI Error */
                .word     IPA_IRQHandler		/* 106:IPA */

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler. 
* As they are weak aliases, any function with the same name will override 
* this definition.
*
*******************************************************************************/
.weak NMI_Handler
.thumb_set NMI_Handler,Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler,Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler,Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler,Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler,Default_Handler

.weak DebugMon_Handler
.thumb_set DebugMon_Handler,Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler,Default_Handler

.weak WWDGT_IRQHandler
.thumb_set WWDGT_IRQHandler,Default_Handler

.weak LVD_IRQHandler
.thumb_set LVD_IRQHandler,Default_Handler

.weak TAMPER_STAMP_IRQHandler
.thumb_set TAMPER_STAMP_IRQHandler,Default_Handler

.weak RTC_WKUP_IRQHandler
.thumb_set RTC_WKUP_IRQHandler,Default_Handler

.weak FMC_IRQHandler
.thumb_set FMC_IRQHandler,Default_Handler

.weak RCU_CTC_IRQHandler
.thumb_set RCU_CTC_IRQHandler,Default_Handler

.weak EXTI0_IRQHandler
.thumb_set EXTI0_IRQHandler,Default_Handler

.weak EXTI1_IRQHandler
.thumb_set EXTI1_IRQHandler,Default_Handler

.weak EXTI2_IRQHandler
.thumb_set EXTI2_IRQHandler,Default_Handler

.weak EXTI3_IRQHandler
.thumb_set EXTI3_IRQHandler,Default_Handler

.weak EXTI4_IRQHandler
.thumb_set EXTI4_IRQHandler,Default_Handler

.weak DMA0_Channel0_IRQHandler
.thumb_set DMA0_Channel0_IRQHandler,Default_Handler

.weak DMA0_Channel1_IRQHandler
.thumb_set DMA0_Channel1_IRQHandler,Default_Handler

.weak DMA0_Channel2_IRQHandler
.thumb_set DMA0_Channel2_IRQHandler,Default_Handler

.weak DMA0_Channel3_IRQHandler
.thumb_set DMA0_Channel3_IRQHandler,Default_Handler

.weak DMA0_Channel4_IRQHandler
.thumb_set DMA0_Channel4_IRQHandler,Default_Handler

.weak DMA0_Channel5_IRQHandler
.thumb_set DMA0_Channel5_IRQHandler,Default_Handler

.weak DMA0_Channel6_IRQHandler
.thumb_set DMA0_Channel6_IRQHandler,Default_Handler

.weak ADC_IRQHandler
.thumb_set ADC_IRQHandler,Default_Handler

.weak CAN0_TX_IRQHandler
.thumb_set CAN0_TX_IRQHandler,Default_Handler

.weak CAN0_RX0_IRQHandler
.thumb_set CAN0_RX0_IRQHandler,Default_Handler

.weak CAN0_RX1_IRQHandler
.thumb_set CAN0_RX1_IRQHandler,Default_Handler

.weak CAN0_EWMC_IRQHandler
.thumb_set CAN0_EWMC_IRQHandler,Default_Handler

.weak EXTI5_9_IRQHandler
.thumb_set EXTI5_9_IRQHandler,Default_Handler

.weak TIMER0_BRK_TIMER8_IRQHandler
.thumb_set TIMER0_BRK_TIMER8_IRQHandler,Default_Handler

.weak TIMER0_UP_TIMER9_IRQHandler
.thumb_set TIMER0_UP_TIMER9_IRQHandler,Default_Handler

.weak TIMER0_TRG_CMT_TIMER10_IRQHandler
.thumb_set TIMER0_TRG_CMT_TIMER10_IRQHandler,Default_Handler

.weak TIMER0_Channel_IRQHandler
.thumb_set TIMER0_Channel_IRQHandler,Default_Handler

.weak TIMER1_IRQHandler
.thumb_set TIMER1_IRQHandler,Default_Handler

.weak TIMER2_IRQHandler
.thumb_set TIMER2_IRQHandler,Default_Handler

.weak TIMER3_IRQHandler
.thumb_set TIMER3_IRQHandler,Default_Handler

.weak I2C0_EV_IRQHandler
.thumb_set I2C0_EV_IRQHandler,Default_Handler

.weak I2C0_ER_IRQHandler
.thumb_set I2C0_ER_IRQHandler,Default_Handler

.weak I2C1_EV_IRQHandler
.thumb_set I2C1_EV_IRQHandler,Default_Handler

.weak I2C1_ER_IRQHandler
.thumb_set I2C1_ER_IRQHandler,Default_Handler

.weak SPI0_IRQHandler
.thumb_set SPI0_IRQHandler,Default_Handler

.weak SPI1_IRQHandler
.thumb_set SPI1_IRQHandler,Default_Handler

.weak USART0_IRQHandler
.thumb_set USART0_IRQHandler,Default_Handler

.weak USART1_IRQHandler
.thumb_set USART1_IRQHandler,Default_Handler

.weak USART2_IRQHandler
.thumb_set USART2_IRQHandler,Default_Handler

.weak EXTI10_15_IRQHandler
.thumb_set EXTI10_15_IRQHandler,Default_Handler

.weak RTC_Alarm_IRQHandler
.thumb_set RTC_Alarm_IRQHandler,Default_Handler

.weak USBFS_WKUP_IRQHandler
.thumb_set USBFS_WKUP_IRQHandler,Default_Handler

.weak TIMER7_BRK_TIMER11_IRQHandler
.thumb_set TIMER7_BRK_TIMER11_IRQHandler,Default_Handler

.weak TIMER7_UP_TIMER12_IRQHandler
.thumb_set TIMER7_UP_TIMER12_IRQHandler,Default_Handler

.weak TIMER7_TRG_CMT_TIMER13_IRQHandler
.thumb_set TIMER7_TRG_CMT_TIMER13_IRQHandler,Default_Handler

.weak TIMER7_Channel_IRQHandler
.thumb_set TIMER7_Channel_IRQHandler,Default_Handler

.weak DMA0_Channel7_IRQHandler
.thumb_set DMA0_Channel7_IRQHandler,Default_Handler

.weak EXMC_IRQHandler
.thumb_set EXMC_IRQHandler,Default_Handler

.weak SDIO_IRQHandler
.thumb_set SDIO_IRQHandler,Default_Handler

.weak TIMER4_IRQHandler
.thumb_set TIMER4_IRQHandler,Default_Handler

.weak SPI2_IRQHandler
.thumb_set SPI2_IRQHandler,Default_Handler

.weak UART3_IRQHandler
.thumb_set UART3_IRQHandler,Default_Handler

.weak UART4_IRQHandler
.thumb_set UART4_IRQHandler,Default_Handler

.weak TIMER5_DAC_IRQHandler
.thumb_set TIMER5_DAC_IRQHandler,Default_Handler

.weak TIMER6_IRQHandler
.thumb_set TIMER6_IRQHandler,Default_Handler

.weak DMA1_Channel0_IRQHandler
.thumb_set DMA1_Channel0_IRQHandler,Default_Handler

.weak DMA1_Channel1_IRQHandler
.thumb_set DMA1_Channel1_IRQHandler,Default_Handler

.weak DMA1_Channel2_IRQHandler
.thumb_set DMA1_Channel2_IRQHandler,Default_Handler

.weak DMA1_Channel3_IRQHandler
.thumb_set DMA1_Channel3_IRQHandler,Default_Handler

.weak DMA1_Channel4_IRQHandler
.thumb_set DMA1_Channel4_IRQHandler,Default_Handler

.weak ENET_IRQHandler
.thumb_set ENET_IRQHandler,Default_Handler

.weak ENET_WKUP_IRQHandler
.thumb_set ENET_WKUP_IRQHandler,Default_Handler

.weak CAN1_TX_IRQHandler
.thumb_set CAN1_TX_IRQHandler,Default_Handler

.weak CAN1_RX0_IRQHandler
.thumb_set CAN1_RX0_IRQHandler,Default_Handler

.weak CAN1_RX1_IRQHandler
.thumb_set CAN1_RX1_IRQHandler,Default_Handler

.weak CAN1_EWMC_IRQHandler
.thumb_set CAN1_EWMC_IRQHandler,Default_Handler

.weak USBFS_IRQHandler
.thumb_set USBFS_IRQHandler,Default_Handler

.weak DMA1_Channel5_IRQHandler
.thumb_set DMA1_Channel5_IRQHandler,Default_Handler

.weak DMA1_Channel6_IRQHandler
.thumb_set DMA1_Channel6_IRQHandler,Default_Handler

.weak DMA1_Channel7_IRQHandler
.thumb_set DMA1_Channel7_IRQHandler,Default_Handler

.weak USART5_IRQHandler
.thumb_set USART5_IRQHandler,Default_Handler

.weak I2C2_EV_IRQHandler
.thumb_set I2C2_EV_IRQHandler,Default_Handler

.weak I2C2_ER_IRQHandler
.thumb_set I2C2_ER_IRQHandler,Default_Handler

.weak USBHS_EP1_Out_IRQHandler
.thumb_set USBHS_EP1_Out_IRQHandler,Default_Handler

.weak USBHS_EP1_In_IRQHandler
.thumb_set USBHS_EP1_In_IRQHandler,Default_Handler

.weak USBHS_WKUP_IRQHandler
.thumb_set USBHS_WKUP_IRQHandler,Default_Handler

.weak USBHS_IRQHandler
.thumb_set USBHS_IRQHandler,Default_Handler

.weak DCI_IRQHandler
.thumb_set DCI_IRQHandler,Default_Handler

.weak TRNG_IRQHandler
.thumb_set TRNG_IRQHandler,Default_Handler

.weak FPU_IRQHandler
.thumb_set FPU_IRQHandler,Default_Handler

.weak UART6_IRQHandler
.thumb_set UART6_IRQHandler,Default_Handler

.weak UART7_IRQHandler
.thumb_set UART7_IRQHandler,Default_Handler

.weak SPI3_IRQHandler
.thumb_set SPI3_IRQHandler,Default_Handler

.weak SPI4_IRQHandler
.thumb_set SPI4_IRQHandler,Default_Handler

.weak SPI5_IRQHandler
.thumb_set SPI5_IRQHandler,Default_Handler

.weak TLI_IRQHandler
.thumb_set TLI_IRQHandler,Default_Handler

.weak TLI_ER_IRQHandler
.thumb_set TLI_ER_IRQHandler,Default_Handler

.weak IPA_IRQHandler
.thumb_set IPA_IRQHandler,Default_Handler

