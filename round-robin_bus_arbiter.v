`timescale 1ns / 1ps

module round_robin_bus_arbiter(
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);

    reg [2:0] current_state;
    reg [2:0] next_state;

    parameter [2:0] s_ideal = 3'b000;
    parameter [2:0] s0 = 3'b001;
    parameter [2:0] s1 = 3'b010;
    parameter [2:0] s2 = 3'b011;
    parameter [2:0] s3 = 3'b100;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            current_state <= s_ideal;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state; 
        case (current_state)
            s_ideal: begin
                if (req[0])
                    next_state = s0;
                else if (req[1])
                    next_state = s1;
                else if (req[2])
                    next_state = s2;
                else if (req[3])
                    next_state = s3;
            end
            s0: begin
                if (req[1])
                    next_state = s1;
                else if (req[2])
                    next_state = s2;
                else if (req[3])
                    next_state = s3;
                else if (req[0])
                    next_state = s0;
                else
                    next_state = s_ideal;
            end
            s1: begin
                if (req[2])
                    next_state = s2;
                else if (req[3])
                    next_state = s3;
                else if (req[0])
                    next_state = s0;
                else if (req[1])
                    next_state = s1;
                else
                    next_state = s_ideal;
            end
            s2: begin
                if (req[3])
                    next_state = s3;
                else if (req[0])
                    next_state = s0;
                else if (req[1])
                    next_state = s1;
                else if (req[2])
                    next_state = s2;
                else
                    next_state = s_ideal;
            end
            s3: begin
                if (req[0])
                    next_state = s0;
                else if (req[1])
                    next_state = s1;
                else if (req[2])
                    next_state = s2;
                else if (req[3])
                    next_state = s3;
                else
                    next_state = s_ideal;
            end
            default: next_state = s_ideal;
        endcase
    end

    always @(*) begin
        grant = 4'b0000; 
        case (current_state)
            s0: grant = 4'b0001;
            s1: grant = 4'b0010;
            s2: grant = 4'b0100;
            s3: grant = 4'b1000;
            default: grant = 4'b0000;
        endcase
    end

endmodule
