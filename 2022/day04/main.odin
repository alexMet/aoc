package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Range :: struct{x, y: int}

is_fully_contained :: proc(range1, range2: Range) -> bool {
    return range2.x >= range1.x && range2.y <= range1.y
}

is_fully_excluded :: proc(range1, range2: Range) -> bool {
    return range2.x > range1.y || range2.y < range1.x
}

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1
	}
	defer delete(data, context.allocator)

    fully_inclusive_ranges: int = 0
    partially_inclusive_ranges: int = 0
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        ranges := strings.split(line, ",")
        first_elf_range := strings.split(ranges[0], "-")
        second_elf_range := strings.split(ranges[1], "-")
        range1 := Range{
            strconv.atoi(first_elf_range[0]),
            strconv.atoi(first_elf_range[1]),
        }
        range2 := Range{
            strconv.atoi(second_elf_range[0]),
            strconv.atoi(second_elf_range[1]),
        }

        fully_inclusive_ranges += (is_fully_contained(range1, range2) || is_fully_contained(range2, range1)) ? 1 : 0
        partially_inclusive_ranges += (is_fully_excluded(range1, range2)) ? 0 : 1
    }

    return fully_inclusive_ranges, partially_inclusive_ranges
}

main :: proc() {
    x, y := solve("day04/test.txt")
    assert(x == 2)
    assert(y == 4)
    x, y = solve("day04/input.txt")
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
