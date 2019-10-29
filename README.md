### CRC原理
---

网上查了些资料，总感觉写的不够详尽，这里根据自己的理解进行了整理。



**CRC是干什么的**

CRC：**C**yclic **R**edundancy **C**heck，即循环冗余检测，是用来检测信息是否出现错误或被干扰；也有将CRC理解成**C**yclic **R**edundance **C**ode，即循环冗余码。<br>

我更倾向于理解成循环冗余检测，即检测是否有错误。<br>



**CRC检测原理**

网上有很多资料进行介绍，这里按我自己的理解来说，就是**判断数据的余数是否为0，为0则数据是正确的，否则为错误的**。既然是求余数，那么被除数(即数据)是怎么来的？除数是怎么来的？说清楚了这2个问题，也就明白了CRC的原理。<br>

这里以13/4为例，这里的被除数为13，除数为4，可以看到余数为1，不为0。很明显，(13-1)/4的余数才是0。<br>

上面的这个例子就体现了CRC的原理：被除数(实际数据+余数)/除数，如果为0，则数据正确，如果不为0，则数据错误。<br>

**被除数**：实际信息+余数；<br>

**除数**：公认标准，也可以自己选择，不过使用过程中统一就行；<br>

**余数**：被除数/除数得到；<br>



**CRC相关术语**

在实际的实现过程中，可能存在一些差异，因而也就造成了一些术语，这里进行了整理，如下表所示：


术语/参数 | 含义
---|---
校验和位宽W | 校验数据的位宽，即余数的位宽
生成多项式 | 用来生成余数，即除数
初始值 | 余数的初始值
Refin | 输入数据是否翻转
Refout | 输出数据(余数)是否翻转
Xorout | 异或值

> 输入数据翻转是对数据的每个字节，而不是所有数据：如`08 32 5D`，翻转后为`10 4C BA` <br>
> 输出数据翻转是对输出数据(余数)整个翻转，如余数为16位`08 32`，翻转后为`4C 10`<br>



**主要标准**

名称 | 多项式 | 初始值 | 输入翻转 | 输出翻转 | 异或值 | 引用标准/用途
---|---|---|---|---|---|---
CRC-1 | 0x01 | - | - | - | - | 硬件，也称奇偶校验位
CRC-4-ITU | 0x03 | 0x00 | True | True | 0x00 | ITU G.704 
CRC-5-CCITT | 0x0B | - | - | - | - | ITU G.704 
CRC-5-EPC | 0x09 | 0x09 | False | False | 0x00 |  
CRC-5-ITU | 0x15 | 0x00 | True | True | 0x00 |  
CRC-5-USB | 0x05 | 0x1F | True | True | 0x1F | USB信令包
CRC-6-ITU | 0x03 | 0x00 | True | True | 0x00 | 
CRC-7 | 0x09 | 0x00 | False | False | 0x00 | 通讯系统
CRC-8-ATM | 0x07 | 0x00 | False | False | 0x00 | ATM HEC
CRC-8-ITU | 0x07 | 0x00 | False | False | 0x55 | 
CRC-8-ROHC | 0x07 | 0xFF | True | True | 0x00 | 
CRC-8-CCITT | 0x8D | - | - | - | - | 1-wire总线
CRC-8-MAXIM | 0x31 | 0x00 | True | True | 0x00 | 1-wirebus
CRC-8 | 0xD5 | - | - | - | - | - 
CRC-10 | 0x233 | - | - | - | - | - 
CRC-12 | 0x80F | - | - | - | - | 通讯系统 
CRC-16-CCITT | 0x1021 | 0x0000 | True | True | 0x0000 | X25、V.41、Bluetooth、PPP、IrDA
CRC-16-CCITT-FALSE | 0x1021 | 0xFFFF | False | False | 0x0000 | X25、V.41、Bluetooth、PPP、IrDA 
CRC-16-XMODEM | 0x1021 | 0x0000 | False | False | 0x0000 |  
CRC-16-X25 | 0x1021 | 0xFFFF | True | True | 0xFFFF |  
CRC-16-MODBUS | 0x8005 | 0xFFFF | True | True | 0x0000 |  
CRC-16-IBM | 0x8005 | 0x0000 | True | True | 0x0000 | Modbus
CRC-16-MAXIM | 0x8005 | 0x0000 | True | True | 0xFFFF | 
CRC-16-USB | 0x8005 | 0xFFFF | True | True | 0xFFFF | 
CRC-16-DNP | 0x3D65 | 0x0000 | True | True | 0xFFFF | M-Bus 
CRC-16-BBS | 0x8408 | - | - | - | - | XMODEM协议
CRC-32 | 0x04C11DB7 | 0xFFFFFFFF | True | True | 0xFFFFFFFF | IEEE802.3、WinRAR等 
CRC-32-MPEG2 | 0x04C11DB7 | 0xFFFFFFFF | False | False | 0x00000000 |  
CRC-32C | 0x1EDC6F41 | 0xFFFFFFFF | True | True | 0xFFFFFFFF | SCTP 
CRC-64-ISO | 0x000000000000001B | - | - | - | - | ISO 3309
CRC-64-ECMA-182 | 0x42F0E1EBA9EA3693 | - | - | - | - | ECMA-182



**生成多项式**

生成多项式表示的是除数的二进制形式，对应幂次前面的系数为对应bit位，由于二进制最高位恒为1，因而简记时将其去除了。<br>
常见生成多项式有：

 生成多项式 | 位宽 | 简记
---|---|---
 $x+1$ | 0 | 0x01
 $x^4+x+1$ | 4 | 0x03 
 $x^5+x^3+x+1$ | 5 | 0x0B
 $x^5+x^3+1$ | 5 | 0x09 
 $x^5+x^2+1$ | 5 | 0x05
 $x^5+x^4+x^2+1$ | 5 | 0x15 
 $x^6+x+1$ | 6 | 0x03 
 $x^7+x^3+1$ | 7 | 0x09
 $x^8+x^2+1$ | 8 | 0x07
 $x^8+x^7+x^3+x^2+1$ | 8 | 0x8D
 $x^8+x^5+x^4+1$ | 8 | 0x31
 $x^8+x^7+x^6+x^4+x^2+1$ | 8 | 0xD5
 $x^{10}+x^9+x^5+x^4+x+1$ | 10 | 0x233
 $x^{12}+x^{11}+x^3+x^2+x+1$ | 12 | 0x80F
 $x^{16}+x^{12}+x^5+1$ | 16 | 0x1021
 $x^{16}+x^{15}+x^2+1$ | 16 | 0x8005
 $x^{16}+x^{15}+x^{10}+x^3$ | 16 | 0x8408
 $x^{16}+x^{13}+x^{12}+x^{11}$<br>$+x^{10}+x^8+x^6+x^5+x^2+1$ | 16 | 0x3D65 
 $x^{32}+x^{26}+x^{23}+x^{22}$<br>$+x^{16}+x^{12}+x^{11}+x^{10}$<br>$+x^8+x^7+x^5+x^4+x^2+x+1$ | 32 | 0x04C11DB7
 $x^{32}+x^{28}+x^{27}+x^{26}$<br>$+x^{25}+x^{23}+x^{22}+x^{20}$<br>$+x^{19}+x^{18}+x^{14}+x^{13}$<br>$+x^{11}+x^{10}+x^9+x^8+x^6+1$ | 32 | 0x1EDC6F41
 $x^{64}+x^4+x^3+x+1$ | 64 | 000000000000001B
 $x^{64}+x^{62}+x^{57}+x^{55}$<br>$+x^{54}+x^{53}+x^{52}+x^{47}$<br>$+x^{46}+x^{45}+x^{40}+x^{39}$<br>$+x^{38}+x^{37}+x^{35}+x^{33}$<br>$+x^{32}+x^{31}+x^{29}+x^{27}$<br>$+x^{24}+x^{23}+x^{22}+x^{21}$<br>$+x^{19}+x^{17}+x^{13}+x^{12}$<br>$+x^{10}+x^9+x^7+x^4+x+1$ | 64 | 0x42F0E1EBA9EA3693



**计算过程**

这里仅对查表法过程进行说明：

| 正向                                                         | 反向                                                     |
| ------------------------------------------------------------ | -------------------------------------------------------- |
| 初始化CRC寄存器                                              | 初始化CRC寄存器                                          |
| 根据refin，对输入数据每个字节进行处理得到temp                | 根据refin，对输入数据每个字节进行处理得到temp            |
| CRC**最高**字节与temp异或，得到**temp1=(CRC>>width-8)^temp** | CRC**最低**字节与temp异或，得到**temp1=(CRC^temp)&0xFF** |
| CRC**左移**一个字节，得到**CRC1=CRC<<8**                     | CRC**右移**一个字节，得到**CRC1=CRC>>8**                 |
| 在table中查找信息并于CRC异或，CRC=table[temp1]^CRC1          | 在table中查找信息并于CRC异或，CRC=table[temp1]^CRC1      |
| 重复步骤2~5，知道处理完所有数据                              | 重复步骤2~5，知道处理完所有数据                          |
| 根据refout，对输出数据进行处理得到CRC                        | 根据refout，对输出数据进行处理得到CRC                    |
| 与xorval异或，得到最终CRC                                    | 与xorval异或，得到最终CRC                                |

在实现过程，多采用反向现实，主要原因有：

- 反向实现，需要的位移少，速度更快；
- 较多的标准，refin、refout都为True，采用返现反向实现，可以不进行处理，速度更快；

除了上述处理过程不同，正向、反向方法区别还有：

- **反向实现时，对正向refin、refout取反**
- **反向实现的table可以由正向实现得到的table转换得到**



**计算实例**

| 正向                                                         | 反向                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| data=47<br>ploy=8005<br>width=16<br>init=0xFFFF<br>xorval=0xFFFF<br>refin=True<br>refout=True | data=47<br/>ploy=8005<br/>width=16<br/>init=0xFFFF<br/>xorval=0xFFFF<br/>refin=True<br/>refout=True |
| 初始化CRC=FFFF                                               | 初始化CRC=FFFF                                               |
| refin=True，data翻转处理，data=1111 0100                     | refin取反，data不需要翻转处理，data=0010 1111                |
| 与CRC最高字节(FF)异或，temp=0000 1011                        | 与CRC最低字(FF)节异或，temp=1101 0000                        |
| CRC左移1个字节，CRC1=0xFF00                                  | CRC右移1个字节，CRC1=0x00FF                                  |
| table查找结果为：0x8039，与CRC1异或为：0x7F39                | table查找结果为：0x9C01，与CRC1异或为：0x9CFE                |
| refout=True，CRC翻转处理，CRC=0x9CFE                         | refout取反，CRC不需要处理，CRC=0x9CFE                        |
| 与xorval异或，得到CRC为：0x6301                              | 与xorval异或，得到CRC为：0x6301                              |



**demo**

> 直接运行 test\_crc.m 或 test\_crc\_1.m

