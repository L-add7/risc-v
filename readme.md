# RISC-V 五级流水线CPU

## RV32I指令集

![image-20240520171709339](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520171709339.png)

在该工程中，实现了上述RV32I的基础指令集，具体的各个指令功能可以参照文件中的riscv-card。

## 冒险处理

1.ALU->ALU的冒险，在这里分为三种，

ALU->ALU(两条指令相邻，下一条指令用到了上一条指令的处理结果)

ALU-> -> ALU(两条中间隔了一条指令，下一条指令用到了上上一条指令的处理结果)

ALU-> ->  ->ALU(两条中间隔了两条指令，下一条指令用到了上上上一条指令的处理结果)

在这里均使用forward logic解决，除此之外针对中间相隔两条的情况，还可以使用regfile在下降沿写入数据。

对应于 ： cpu_tb.v Hazard 1-6

2.two alu，three alu冒险

ALU 在运算时要使用到之前指令得到的两个寄存器值

该冒险类似于第一条，使用forward logic解决即可

对应于 ： cpu_tb.v Hazard 7-8

3.MEM <-> ALU、MEM->MEM冒险

在这里主要是指store load指令与ALU交互时存在的冒险

对于ALU -> MEM 这里是指上一条指令修改寄存器的值， store指令需要用到ALU的结果。使用forward logic 解决即可

对于MEM ->MEM、MEM->ALU这里是指load指令存在的冒险，由于load指令取出数据较晚，不能使用forward logic解决，需要将流水线停顿，直到取出正确正确数据为止。

对应于 ： cpu_tb.v Hazard 9-11

4.Branch 产生的冒险

主要考虑分支跳转，为了保证cpi，我们这边使用了最简单的动态分支预测，即使用2bit饱和计数器

所谓2-bit计数器，即每条指令PC,通过一个2-bit的计数器，记录历史跳转情况：

（1）2-bit所能记录的数字包含00/01/10/11。

（2）分支实际跳转一次，计数器+1，不跳转，则-1。

（3）2-bit计数器当前状态为10或者11，则预测本次跳转，如果为00或者01，则预测本次不跳转。

实际研究表明，2-bit计数器相较于1-bit精度较高，如果再提高到3-bit，精度提升不明显。因此业界大多使用2-bit计数器。
![image-20240520185919349](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520185919349.png)

在分支预测失败时，我们需要产生flush信号来冲刷掉之前进行的信号。

对应于 ： cpu_tb.v Hazard 12

5.JAL、JALR 写回冒险

同1、2,还是ALU数据的问题使用forward logic即可

对应于 ： cpu_tb.v Hazard 13-14

## 结果电路图

![image-20240520191056785](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520191056785.png)

## 仿真结果

![image-20240520190607110](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520190607110.png)

![image-20240520190645557](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520190645557.png)

## 综合布线结果

资源用量

![image-20240520162641982](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520162641982.png)

各模块消耗量

![image-20240520162704050](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520162704050.png)

然而不幸的是，我的是时序报告如下：

![image-20240520171141358](/home/lijiaqi/.config/Typora/typora-user-images/image-20240520171141358.png)

这说明时序很好，所以也无法算出最大频率——感觉是时序约束错了（可能，不太懂）