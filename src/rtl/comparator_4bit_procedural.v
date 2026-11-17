// ---------------------------------------------------------------------------
//  comparator_4bit_procedural.v
//  4-bit magnitude comparator - procedural (behavioural) model.
//
//  PROVENANCE
//    Faithfully reconstructed from the original CSE345 project report
//    "Project report on 4-bit Magnitude Comparator", Group 7,
//    Dept. of Computer Science and Engineering, East West University,
//    submitted September 2nd, 2025 - Section 7, "Procedural Model".
//
//    The executable content is unchanged from the version printed in the
//    report. The only editorial change is that the inline comments, which
//    were offset by one line in the printed report, are aligned with the
//    statements they actually describe. See CHANGELOG.md.
//
//    Original work: Group 7, East West University (CSE345), 2025.
//    File reconstructed during the 2026 repository organisation.
// ---------------------------------------------------------------------------

module comparator_4bit_procedural (
    input [3:0] A,      // 4-bit input A (A3 to A0)
    input [3:0] B,      // 4-bit input B (B3 to B0)
    output reg GT,      // Output: 1 if A > B
    output reg EQ,      // Output: 1 if A == B
    output reg LT       // Output: 1 if A < B
);

always @(*) begin       // Triggered on any change in inputs
    if (A > B) begin    // If A is greater than B
        GT = 1;         // Set GT high
        EQ = 0;         // EQ and LT low
        LT = 0;
    end else if (A == B) begin  // If A equals B
        GT = 0;         // GT low
        EQ = 1;         // Set EQ high
        LT = 0;         // LT low
    end else begin      // Otherwise, A < B
        GT = 0;         // GT low
        EQ = 0;         // EQ low
        LT = 1;         // Set LT high
    end
end

endmodule
