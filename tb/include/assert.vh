`ifndef _ASSERT_VH
`define _ASSERT_VH

`define ASSERT(_expected, _actual) \
    if (_expected !== _actual) begin \
        $display("ASSERTION FAILED\n  %m:%0d - Expected %b, but got %b", `__LINE__, _expected, _actual); \
        $finish; \
    end

`define ASSERT_W_MSG(_expected, _actual, _msg) \
    $write("%s - ", _msg); \
    `ASSERT(_expected, _actual) \
    $display("PASSED");

`endif
