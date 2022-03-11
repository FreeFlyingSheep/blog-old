---
title: "Valgrind for LoongArch"
date: 2021-12-27
tags: ["Valgrind", "LoongArch"]
categories: ["Valgrind"]
---

简单介绍移植 Valgrind for LoongArch 的过程。

<!--more-->

## LibVEX

### 前端

TODO

### 后端

TODO

### 汇总

用到的字节序：

- `Iend_LE`：LoongArch 只有小端序

用到的常量：

- `Ico_F32i`：主要用于表示浮点数 `1.0`
- `Ico_F64i`：主要用于表示浮点数 `1.0`
- `Ico_U16`：主要用于表示 16 位立即数
- `Ico_U32`：主要用于表示 32 位立即数
- `Ico_U64`：主要用于表示 `pc` 寄存器和 64 位立即数
- `Ico_U8`：主要用于表示 `ui5`、`ui6`、`sa2`、`sa3`、`msbw`、`lsbw`、`msbd`、`lsbd` 和 8 位立即数
- `Ico_U1`：主要用于表示比较运算的结果

用到的类型：

- `Ity_F32`：主要用于浮点寄存器的低 32 位
- `Ity_F64`：主要用于浮点寄存器
- `Ity_I16`：主要用于整数寄存器的低 16 位
- `Ity_I32`：主要用于整数寄存器的低 32 位
- `Ity_I64`：主要用于整数寄存器
- `Ity_I8`：主要用于整数寄存器的低 8 位和 `fcc` 寄存器
- `Ity_I1`：主要用于整数寄存器的低 1 位

用到的操作符（浮点指令基本都涉及 `fcsr` 的保存和恢复）：

- `Iop_128HIto64`：`return hi`
- `Iop_128to64`：`return lo`
- `Iop_16Sto64`：`ext.w.h dst, src`
- `Iop_16Uto64`：`slli.d dst, src, 48; srli.d dst, dst, 48`
- `Iop_1Sto64`：`slli.d dst, src, 63; srai.d dst, dst, 63`
- `Iop_1Uto32`：`andi dst, src, 0x1`
- `Iop_1Uto64`：`andi dst, src, 0x1`
- `Iop_1Uto8`：`andi dst, src, 0x1`
- `Iop_32Sto64`：`add.w dst, src, $zero`
- `Iop_32Uto64`：`slli.d dst, src, 32; srli.d dst, dst, 32`
- `Iop_32to8`：`andi dst, src, 0xff`
- `Iop_64HIto32`：`srli.d dst, src, 32`
- `Iop_64to32`：`slli.d dst, src, 32; srli.d dst, dst, 32`
- `Iop_64to8`：`andi dst, src, 0xff`
- `Iop_8Sto64`：`ext.w.b dst, src`
- `Iop_8Uto32`：`andi dst, src, 0xff`
- `Iop_8Uto64`：`andi dst, src, 0xff`
- `Iop_AbsF32`：`fabs.s dst, src`
- `Iop_AbsF64`：`fabs.d dst, src`
- `Iop_Add32`：`add[i].w dst, src1, src2`
- `Iop_Add64`：`add[i].d dst, src1, src2`
- `Iop_AddF32`：`fadd.s dst, src1, src2`
- `Iop_AddF64`：`fadd.d dst, src1, src2`
- `Iop_And32`：`and[i] dst, src1, src2`
- `Iop_And64`：`and[i] dst, src1, src2`
- `Iop_Clz32`：`clz.w dst, src`
- `Iop_Clz64`：`clz.d dst, src`
- `Iop_CmpEQ32`：`xor dst, src1, src2; sltui dst, dst, 1`
- `Iop_CmpEQ64`：`xor dst, src1, src2; sltui dst, dst, 1`
- `Iop_CmpF32`：`fcmp.cond.s dst, src1, src2`
- `Iop_CmpF64`：`fcmp.cond.d dst, src1, src2`
- `Iop_CmpLT32S`：`slli.w src1, src1, 0; slli.w src2, src2, 0; slt dst, src1, src2`
- `Iop_CmpLT32U`：`slli.w src1, src1, 0; slli.w src2, src2, 0; sltu dst, src1, src2`
- `Iop_CmpLE64S`：`slt dst, src2, src1; nor dst, src, $zero`
- `Iop_CmpLE64U`：`sltu dst, src2, src1; nor dst, src, $zero`
- `Iop_CmpLT64S`：`slt dst, src1, src2`
- `Iop_CmpLT64U`：`sltu dst, src1, src2`
- `Iop_CmpNE32`：`xor dst, src1, src2; sltu dst, $zero, dst`
- `Iop_CmpNE64`：`xor dst, src1, src2; sltu dst, $zero, dst`
- `Iop_Ctz32`：`ctz.w dst, src`
- `Iop_Ctz64`：`ctz.d dst, src`
- `Iop_DivF32`：`fdiv.s dst, src1, src2`
- `Iop_DivF64`：`fdiv.d dst, src1, src2`
- `Iop_DivModS32to32`：`div.w lo, src1, src2; mod.w hi, src1, src2; slli.d hi, hi, 6; or dst, lo, hi`
- `Iop_DivModS64to64`：`div.d lo, src1, src2; mod.d hi, src1, src2`
- `Iop_DivModU32to32`：`div.wu lo, src1, src2; mod.wu hi, src1, src2; slli.d hi, hi, 6; or dst, lo, hi`
- `Iop_DivModU64to64`：`div.du lo, src1, src2; mod.du hi, src1, src2`
- `Iop_DivS32`：`div.w dst, src1, src2`
- `Iop_DivS64`：`div.wu dst, src1, src2`
- `Iop_DivU32`：`div.d dst, src1, src2`
- `Iop_DivU64`：`div.du dst, src1, src2`
- `Iop_F32toF64`：`fcvt.s.d dst, src`
- `Iop_F32toI32S`：`ftint.w.s dst, src`
- `Iop_F32toI64S`：`ftint.l.s dst, src`
- `Iop_F64toF32`：`fcvt.s.d dst, src`
- `Iop_F64toI32S`：`ftint.w.d dst, src`
- `Iop_F64toI64S`：`ftint.l.d dst, src`
- `Iop_I32StoF32`：`ffint.s.w dst, src`
- `Iop_I32StoF64`：`ffint.d.w dst, src`
- `Iop_I64StoF32`：`ffint.s.l dst, src`
- `Iop_I64StoF64`：`ffint.d.l dst, src`
- `Iop_MAddF32`：`fmadd.s dst, src1, src2, src3`
- `Iop_MAddF64`：`fmadd.d dst, src1, src2, src3`
- `Iop_MSubF32`：`fmsub.s dst, src1, src2, src3`
- `Iop_MSubF64`：`fmsub.d dst, src1, src2, src3`
- `Iop_MaxNumF32`：`fmax.s dst, src1, src2`
- `Iop_MaxNumF64`：`fmax.d dst, src1, src2`
- `Iop_MinNumF32`：`fmin.s dst, src1, src2`
- `Iop_MinNumF64`：`fmin.d dst, src1, src2`
- `Iop_MulF32`：`fmul.s dst, src1, src2`
- `Iop_MulF64`：`fmul.d dst, src1, src2`
- `Iop_MullS32`：`mulw.d.w dst, src1, src2`
- `Iop_MullS64`：`mul.d lo, src1, src2; mulh.d hi, src1, src2`
- `Iop_MullU32`：`mulw.d.wu dst, src1, src2`
- `Iop_MullU64`：`mul.d lo, src1, src2; mulh.du hi, src1, src2`
- `Iop_NegF32`：`fneg.s dst, src`
- `Iop_NegF64`：`fneg.d dst, src`
- `Iop_Not32`：`nor dst, src, $zero`
- `Iop_Not64`：`nor dst, src, $zero`
- `Iop_Or1`：`or dst, src1, src2`
- `Iop_Or32`：`or[i] dst, src1, src2`
- `Iop_Or64`：`or[i] dst, src1, src2`
- `Iop_ReinterpF32asI32`：`movfr2gr.s dst, src`
- `Iop_ReinterpF64asI64`：`movfr2gr.d dst, src`
- `Iop_ReinterpI32asF32`：`movgr2fr.w dst, src`
- `Iop_ReinterpI64asF64`：`movgr2fr.d dst, src`
- `Iop_RoundF32toInt`：`frint.s dst, src`
- `Iop_RoundF64toInt`：`frint.d dst, src`
- `Iop_Sar32`：`sra[i].w dst, src1, src2`
- `Iop_Sar64`：`sra[i].d dst, src1, src2`
- `Iop_Shl32`：`sll[i].w dst, src1, src2`
- `Iop_Shl64`：`sll[i].d dst, src1, src2`
- `Iop_Shr32`：`srl[i].w dst, src1, src2`
- `Iop_Shr64`：`srl[i].d dst, src1, src2`
- `Iop_SqrtF32`：`fsqrt.s dst, src`
- `Iop_SqrtF64`：`fsqrt.s dst, src`
- `Iop_Sub32`：`sub.w dst, src1, src2`
- `Iop_Sub64`：`sub.d dst, src1, src2`
- `Iop_SubF32`：`fsub.s dst, src1, src2`
- `Iop_SubF64`：`fsub.d dst, src1, src2`
- `Iop_Xor32`：`xor[i] dst, src1, src2`
- `Iop_Xor64`：`xor[i] dst, src1, src2`

用到的表达式：

- `Iex_Binop`：用于表示二元操作符和对应的操作数
- `Iex_Const`：用于表示常量
- `Iex_Get`：用于读寄存器
- `Iex_Load`：用于读内存
- `Iex_Qop`：用于表示四元操作符和对应的操作数
- `Iex_RdTmp`：用于表示读取临时变量
- `Iex_Triop`：用于表示三元操作符和对应的操作数
- `Iex_Unop`：用于表示一元操作符和对应的操作数

用到的跳转方式：

- `Ijk_Boring`：用于表示普通的跳转
- `Ijk_ClientReq`：用于表示需要处理客户端请求（Valgrind 专用）
- `Ijk_SigFPE`：用于表示当前指令触发 `SIGFPE` 异常
- `Ijk_INVALID`：用于表示无效（libVEX 本身出现错误）
- `Ijk_InvalICache`：用于表示需要使指令缓存无效（Valgrind 专用）
- `Ijk_NoDecode`：用于表示解码失败
- `Ijk_NoRedir`：用于表示跳转到未重定向到地址（Valgrind 专用）
- `Ijk_SigSEGV`：用于表示当前指令触发 `SIGSEGV` 异常
- `Ijk_SigTRAP`：用于表示当前指令触发 `SIGTRAP` 异常
- `Ijk_Sys_syscall`：用于表示需要进行系统调用

用到的语句：

- `Ist_CAS`：用于原子操作（Compare And Swap）
- `Ist_Exit`：用于表示退出
- `Ist_LLSC`：用于原子操作（`ll`/`sc`）
- `Ist_MBE`：用于表示内存屏障
- `Ist_Put`：用于表示写寄存器
- `Ist_Store`：用于表示写内存
- `Ist_WrTmp`：用于表示给临时变量赋值

Valgrind 特殊指令：

```text
guard:
srli.d $zero, $zero, 3
srli.d $zero, $zero, 13
srli.d $zero, $zero, 29
srli.d $zero, $zero, 19

$a7 = client_request($t0):
or $t1, $t1, $t1

$a7 = guest_NRADDR:
or $t2, $t2, $t2

call-noredir $t8:
or $t3, $t3, $t3

IR injection:
or $t4, $t4, $t4
```

公共框架添加的内容：

- `Ist_MBE`：添加表示指令屏障的功能
- `Iop_LogBF32`：`flogb.s dst, src`
- `Iop_LogBF64`：`flogb.d dst, src`
- `Iop_ScaleBF32`：`fscaleb.s dst, src1, src2`
- `Iop_ScaleBF64`：`fscaleb.s dst, src1, src2`

除此以外，还有其他 Valgrind 工具（如 memcheck）会用到一些专有操作符（如 `Iop_CmpNEZ8`），也需要在后端翻译，此处略去。

## Valgrind

TODO
