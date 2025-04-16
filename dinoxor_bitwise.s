.global _dinoxor_bitwise

.text

// Function: dinoxor
// Description: Orchestrates a series of operations to replicate a bitwise XOR 
// operation using NEON registers. This function initializes a XOR truth table,
//  calculates an index based on provided Xindex and Yindex, and creates a 
// mask for XOR operations. 
// Arguments:
//   - x0: First operand bit
//   - x1: Second operand bit
// Returns: None directly, but the operations modify NEON registers to set 
// up the environment for XOR operations based on the input indices.
_dinoxor_bitwise:
    // Prologue: Prepare the stack and save callee-saved registers
    stp x29, x30, [sp, #-16]!  // Save the frame pointer and return address
    mov x29, sp                // Update the frame pointer

    // Prepare arguments and call the function (if needed)
    bl prepare_xor_truth_table

    // Call calculate_index
    bl calculate_index

    // Call create mask
    bl create_mask

    // Extract the lowest byte from v0
    umov w0, v0.b[0] // Move the lowest byte of v0 into w0 (32-bit register)

    // Now w0 contains the byte where you want the LSB from
    // Extract the LSB from w0 and keep it in x0 (64-bit register)
    and x0, x0, #0x1 // x0 now has the LSB of the previously extracted byte
    
    // Epilogue: Restore the stack and callee-saved registers
    ldp x29, x30, [sp], #16   // Restore frame pointer and return address
    ret                       // Return to caller

// Function: prepare_xor_truth_table
// Description: Prepares the XOR truth table in a NEON register.
prepare_xor_truth_table:
    // Load a pattern into a general-purpose register.
    movz w0, #0x0001, lsl #16  // Load 0x01 into the second byte from the left
    movk w0, #0x0100           // Overlay 0x01 into the third byte from the left
    
    // Duplicate this value across the 128-bit NEON register lanes
    dup v2.4s, w0 // v2 = {0x00 0x01 0x01 0x00 0x00 0x01 0x01 0x00 0x00 0x01 0x01 0x00 0x00 0x01 0x01 0x00}
    
    ret

// Function: calculate_index
// Description: Calculate the position of a byte in a 2D array represented in 1D
// (Xindex * width) + Yindex
calculate_index:
    // Store the width in x2
    mov x2, #2

    // Calculate the index in a 1D array
    mul x0, x0, x2
    add x0, x0, x1
    ret

// Function: create_mask
// Description: Create a mask in v3 to extract our bit
create_mask:
    // Clear v0, v1, v3, v4
    movi v0.16b, #0
    movi v1.16b, #0
    // Our truth table is in v2
    movi v3.16b, #0
    movi v4.16b, #0

    // Setup our mask
    // Puts 0x0000001 into a general purpose register.
    movz w1, #0x1
    
    // Insert the value from w1 into the lowest 32-bit element (scalar) of v3
    ins v1.s[0], w1

    // Multiply by 8 because we're working with bits
    // This gives us the amount of bits we need to shift
    lsl w0, w0, #3

    // Put the amount of bits we need to shift into v3
    dup v3.2s, w0

    // Split register insto 2 u64s bc who cares and shift
    ushl v1.2d, v1.2d, v3.2d

    // Extract our byte at the specified index using AND
    and v0.16b, v1.16b, v2.16b 

    // Subtracting v3.2d from the zeroed v4.2d to negate the values in v3.2d
    sub v4.2d, v4.2d, v3.2d

    // Now we can use sshl to effectlively achieve the behavior
    // of the unavailable operation "ushr"
    sshl v0.2d, v0.2d, v4.2d
    
    ret