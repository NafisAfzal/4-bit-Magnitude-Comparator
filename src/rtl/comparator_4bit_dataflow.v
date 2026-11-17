// ---------------------------------------------------------------------------
//  comparator_4bit_dataflow.v
//  4-bit magnitude comparator - dataflow (continuous assignment) model.
//
//  PROVENANCE
//    Faithfully reconstructed from the original CSE345 project report
//    "Project report on 4-bit Magnitude Comparator", Group 7,
//    Dept. of Computer Science and Engineering, East West University,
//    submitted September 2nd, 2025 - Section 8, "Continuous Assign Statement
//    (Dataflow Model)".
//
//    The executable content is unchanged from the version printed in the
//    report. The only editorial change is that the inline comments use a
//    single "=" for assignment instead of mixing "==" and "=" as the printed
//    report did. See CHANGELOG.md.
//
//    Original work: Group 7, East West University (CSE345), 2025.
//    File reconstructed during the 2026 repository organisation.
// ---------------------------------------------------------------------------

module comparator_4bit_dataflow (
    input [3:0] A,      // 4-bit input A
    input [3:0] B,      // 4-bit input B
    output GT,          // A > B output
    output EQ,          // A == B output
    output LT           // A < B output
);

assign EQ = (A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] ~^ B[0]);
// EQ is 1 only if all bits match (XNOR for each bit, ANDed together)

assign GT = (A[3] & ~B[3]) |                                // A3 = 1, B3 = 0
            ((A[3] ~^ B[3]) & (A[2] & ~B[2])) |             // A3 = B3 and A2 = 1, B2 = 0
            ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] & ~B[1])) |  // ...and A1 = 1, B1 = 0
            ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] & ~B[0]));
// GT checks from MSB: first unequal bit where A bit is 1 and B is 0

assign LT = (~A[3] & B[3]) |                                // A3 = 0, B3 = 1
            ((A[3] ~^ B[3]) & (~A[2] & B[2])) |             // A3 = B3 and A2 = 0, B2 = 1
            ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (~A[1] & B[1])) |  // ...and A1 = 0, B1 = 1
            ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (~A[0] & B[0]));
// LT is symmetric to GT, but checks where A bit is 0 and B is 1

endmodule
