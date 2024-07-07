/*
模块化：使用 package 语法可以将代码分割成多个逻辑模块，使得代码更加模块化，易于维护和重用。
作用域控制：package 语法可以控制变量和函数的作用域，避免了变量和函数名称冲突的问题。
封装性：使用 package 语法可以将一些私有的变量和函数封装起来，只对外暴露必要的接口，增强了代码的封装性和安全性。
可读性：使用 package 语法可以使代码更加清晰易读，提高了代码的可读性和可维护性。
可重用性：使用 package 语法可以将一些通用的代码封装成库，方便在不同的项目中重用。
使用方法： `include "cache_def.sv"
*/
package cache_def;//data structures for cache tag & data
    parameter int TAGMSB = 31; 
    parameter int TAGLSB = 14;

    //data structure for cache tag
    typedef struct packed {
        bit                 valid;
        bit                 dirty;
        bit [TAGMSB:TAGLSB] tag;
    } cache_tag_type;

    //data structure for cache memory request
    typedef struct {
        bit [9:0]           index; //10 bit index
        bit                 we;    //write enable
    } cache_req_type;

    /*
        typedef struct packed 与 typedef struct的区别：
        默认struct是unpacked的，即地址空间并不连续；需要连续的地址空间，需要packed；
        packed 可以直接整体赋值 即cache_req_type = 9'b
    */
    //128 bit cache line data
    typedef bit [127:0] cache_data_type;
    
    //data structures for CPU <-> Cache controller interface
    //cpu request (cpu -> cache controller)
    typedef struct{
        bit     [31:0]      addr;       // 31:14:tag  13:4:index  3:2:block offset 1:0:Byte offset
        bit     [31:0]      data;
        bit                 rw;         //0 read 1 write
        bit                 valid;      //request ready
    } cpu_req_type;

    //Cache result (cache controller -> cpu)
    typedef struct{
        bit     [31:0]      data;
        bit                 ready;      // resule is ready
    } cpu_resule_type;

    //data structures for cache controller <-> memory interface
    //memory request (cache controller -> memory)
    typedef struct {
        bit     [31:0]      addr;
        bit     [127:0]     data;   // request data (uesd when write)
        bit                 rw;
        bit                 valid;
    } memory_req_type;

    //memory controller response (memory -> cache controller)
    typedef struct {
        cache_data_type     data;
        bit                 ready;
    } mem_data_type;
endpackage