package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

solve :: proc(filepath: string) -> int {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1
	}
	defer delete(data, context.allocator)

    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        smt, ok := strconv.parse_int(line)
        if ok {
            // ...
        }
        else {
            // ...
        }
	}

    return 0
}

main :: proc() {
    x := solve("day0x/test.txt")
    assert(x == 1)
    // x = solve("day0x/input.txt")
	// fmt.println("1st part:", x)
    // fmt.println("2nd part:", x)
}
