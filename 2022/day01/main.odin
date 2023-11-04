package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

swap :: #force_inline proc(a, b: ^int) {
    a^, b^ = b^, a^
}

reorder :: proc(current_elf, first_elf, second_elf, third_elf: ^int) {
    if current_elf^ > third_elf^ {
        swap(current_elf, third_elf)
    }
    if third_elf^ > second_elf^ {
        swap(second_elf, third_elf)
    }
    if second_elf^ > first_elf^ {
        swap(first_elf, second_elf)
    }
}

solve :: proc(filepath: string) -> (int, int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1, -1
	}
	defer delete(data, context.allocator)

    current_elf: int = 0
    first_elf: int = 0
    second_elf: int = 0
    third_elf: int = 0
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        calories, ok := strconv.parse_int(line)
        if ok {
            current_elf += calories
        }
        else {
            reorder(&current_elf, &first_elf, &second_elf, &third_elf)
            current_elf = 0
        }
	}

    reorder(&current_elf, &first_elf, &second_elf, &third_elf)
    return first_elf, second_elf, third_elf
}

main :: proc() {
    x, y, z := solve("day01/test.txt")
    assert(x == 24000)
    assert(x + y + z == 45000)
    x, y, z = solve("day01/input.txt")
	fmt.println("1st part:", x)
    fmt.println("2nd part:", x + y + z)
}
