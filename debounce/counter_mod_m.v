module counter_mod_m # (
    parameter N = 4,
    parameter M = 10
)(  
    input wire clk,rst_n,
    output wire m_out
    );  // 模 M 计数器
    // M 表示模数
    // N 表示计数器能存储的最大位数 大小为 log(2,M) 向上取整。
    reg[N-1:0] regN;

    //计数器主程序
    always @(posedge clk) begin
      if (!rst_n) begin
        regN <= 0;
      end
      else if (regN < M-1) regN <= regN + 1;
      else regN <= 0;
    end

    assign m_out = (regN == (M-1))?1'b1:1'b0;

endmodule