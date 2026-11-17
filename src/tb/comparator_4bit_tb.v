// ---------------------------------------------------------------------------
//  comparator_4bit_tb.v
//  Self-checking testbench for the 4-bit magnitude comparator.
//
//  PROVENANCE - PLEASE READ
//    This file is NEW WORK ADDED IN 2026. It was NOT part of the original
//    CSE345 submission of September 2nd, 2025, which contained only the two
//    RTL models (comparator_4bit_procedural.v and comparator_4bit_dataflow.v)
//    and the Proteus simulations.
//
//    Added in 2026 by: Nafis Afzal
//    Purpose: to verify the two reconstructed RTL models automatically and
//             exhaustively, and to tie the hardware-level results back to a
//             reproducible source-level check.
//
//  WHAT IT DOES
//    1. Sweeps all 16 x 16 = 256 input combinations of (A, B).
//    2. For every combination it compares the outputs of BOTH RTL models
//       against an independent reference model (A > B, A == B, A < B).
//    3. For every combination it also checks that exactly one of the three
//       comparison outputs is high (the one-hot property).
//    4. Re-runs the 13 input vectors that appear in the original Proteus
//       simulation screenshots and prints them as a named regression list.
//
//  HOW TO RUN
//    From the repository root:
//        iverilog -g2005 -Wno-timescale -o build/comparator_4bit_tb.vvp \
//                 src/rtl/comparator_4bit_procedural.v \
//                 src/rtl/comparator_4bit_dataflow.v \
//                 src/tb/comparator_4bit_tb.v
//        vvp build/comparator_4bit_tb.vvp
//
//    (-Wno-timescale suppresses the warning about the two reconstructed RTL
//     files having no timescale directive; they are kept exactly as printed in
//     the 2025 report, and the DUTs are purely combinational.)
//
//    Optional waveform dump (produces build/comparator_4bit_tb.vcd):
//        vvp build/comparator_4bit_tb.vvp +dump
//
//    The run ends with "TESTBENCH RESULT: PASS" and 0 errors when every check
//    passes, and with "TESTBENCH RESULT: FAIL" otherwise.
//
//  Verified with Icarus Verilog 12.0 (iverilog / vvp).
// ---------------------------------------------------------------------------

`timescale 1ns / 1ps

module comparator_4bit_tb;

    // ------------------------------------------------------------------
    // Inputs driven by the testbench
    // ------------------------------------------------------------------
    reg  [3:0] A;
    reg  [3:0] B;

    // Outputs of the procedural (behavioural) model  - original 2025 work
    wire GT_proc, EQ_proc, LT_proc;

    // Outputs of the dataflow model                 - original 2025 work
    wire GT_data, EQ_data, LT_data;

    integer a, b;
    integer checks;
    integer errors;
    integer exp_gt, exp_eq, exp_lt;
    integer regressions;

    // ------------------------------------------------------------------
    // DUT instantiation (named port connections)
    // ------------------------------------------------------------------
    comparator_4bit_procedural dut_proc (
        .A(A), .B(B), .GT(GT_proc), .EQ(EQ_proc), .LT(LT_proc)
    );

    comparator_4bit_dataflow dut_data (
        .A(A), .B(B), .GT(GT_data), .EQ(EQ_data), .LT(LT_data)
    );

    // ------------------------------------------------------------------
    // Compare one input pair against the reference model
    // ------------------------------------------------------------------
    task check_case;
        input [3:0] av;
        input [3:0] bv;
        begin
            A = av;
            B = bv;
            #1;

            exp_gt = (av >  bv) ? 1 : 0;
            exp_eq = (av == bv) ? 1 : 0;
            exp_lt = (av <  bv) ? 1 : 0;

            checks = checks + 1;

            if ((GT_proc !== exp_gt) || (EQ_proc !== exp_eq) || (LT_proc !== exp_lt)) begin
                errors = errors + 1;
                $display("MISMATCH [procedural] A=%b B=%b : got GT=%b EQ=%b LT=%b : expected GT=%b EQ=%b LT=%b",
                         av, bv, GT_proc, EQ_proc, LT_proc, exp_gt, exp_eq, exp_lt);
            end

            if ((GT_data !== exp_gt) || (EQ_data !== exp_eq) || (LT_data !== exp_lt)) begin
                errors = errors + 1;
                $display("MISMATCH [dataflow]   A=%b B=%b : got GT=%b EQ=%b LT=%b : expected GT=%b EQ=%b LT=%b",
                         av, bv, GT_data, EQ_data, LT_data, exp_gt, exp_eq, exp_lt);
            end

            // Exactly one comparison output must be high for any input pair.
            if ((GT_proc + EQ_proc + LT_proc) !== 1) begin
                errors = errors + 1;
                $display("ONE-HOT VIOLATION [procedural] A=%b B=%b GT=%b EQ=%b LT=%b",
                         av, bv, GT_proc, EQ_proc, LT_proc);
            end

            if ((GT_data + EQ_data + LT_data) !== 1) begin
                errors = errors + 1;
                $display("ONE-HOT VIOLATION [dataflow]   A=%b B=%b GT=%b EQ=%b LT=%b",
                         av, bv, GT_data, EQ_data, LT_data);
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Re-run one of the original Proteus vectors and print it by name
    // ------------------------------------------------------------------
    task regression_case;
        input [8*32-1:0] label;
        input [3:0] av;
        input [3:0] bv;
        input [8*8-1:0]  expect;
        begin
            A = av;
            B = bv;
            #1;
            regressions = regressions + 1;
            $display("  Proteus case %0s : A=%b (%0d) B=%b (%0d) -> GT=%b EQ=%b LT=%b   expected %0s",
                     label, av, av, bv, bv, GT_data, EQ_data, LT_data, expect);
        end
    endtask

    // ------------------------------------------------------------------
    initial begin
        checks     = 0;
        errors     = 0;
        regressions = 0;

        A = 4'b0000;
        B = 4'b0000;

        if ($test$plusargs("dump")) begin
            $dumpfile("build/comparator_4bit_tb.vcd");
            $dumpvars(0, comparator_4bit_tb);
        end

        $display("===========================================================");
        $display(" CSE345 - 4-bit Magnitude Comparator - self-checking testbench");
        $display(" Testbench added 2026 by Nafis Afzal (not part of the 2025 submission)");
        $display("===========================================================");
        $display("");

        // --------------------------------------------------------------
        // 1. Exhaustive sweep over all 256 input combinations
        // --------------------------------------------------------------
        $display("Exhaustive sweep: 16 x 16 = 256 input combinations");
        for (a = 0; a < 16; a = a + 1) begin
            for (b = 0; b < 16; b = b + 1) begin
                check_case(a[3:0], b[3:0]);
            end
        end
        $display("  sweep complete.");
        $display("");

        // --------------------------------------------------------------
        // 2. The 13 vectors shown in the original Proteus screenshots
        // --------------------------------------------------------------
        $display("Regression: the 13 input vectors shown in the original Proteus screenshots");
        regression_case("74LS85 p4 ", 4'd0,  4'd0,  "A=B");
        regression_case("74LS85 p5 ", 4'd1,  4'd0,  "A>B");
        regression_case("74LS85 p5 ", 4'd1,  4'd1,  "A=B");
        regression_case("74LS85 p6 ", 4'd3,  4'd1,  "A>B");
        regression_case("74LS85 p6 ", 4'd3,  4'd5,  "A<B");
        regression_case("74LS85 p7 ", 4'd7,  4'd5,  "A>B");
        regression_case("74LS85 p7 ", 4'd9,  4'd8,  "A>B");
        regression_case("74LS85 p8 ", 4'd9,  4'd10, "A<B");
        regression_case("74LS85 p8 ", 4'd12, 4'd11, "A>B");
        regression_case("74LS85 p9 ", 4'd15, 4'd15, "A=B");
        regression_case("gates  p9 ", 4'd0,  4'd0,  "A=B");
        regression_case("gates  p10", 4'd8,  4'd0,  "A>B");
        regression_case("gates  p10", 4'd15, 4'd14, "A>B");
        $display("");

        // --------------------------------------------------------------
        // 3. Summary
        // --------------------------------------------------------------
        $display("-----------------------------------------------------------");
        $display(" Input combinations swept : 256");
        $display(" Regression cases re-run  : %0d", regressions);
        $display(" Checks performed          : %0d", checks);
        $display(" Errors                    : %0d", errors);
        $display("-----------------------------------------------------------");
        if (errors == 0) begin
            $display(" TESTBENCH RESULT: PASS");
            $display("-----------------------------------------------------------");
            $finish;
        end else begin
            $display(" TESTBENCH RESULT: FAIL");
            $display("-----------------------------------------------------------");
            $fatal(1, "Testbench failed with %0d error(s).", errors);
        end
    end

endmodule
