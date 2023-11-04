package main

import "core:fmt"
import "core:os"
import "core:strings"

Item_Types :: bit_set['A'..='z']

count :: proc(set: ^Item_Types, x, y: rune, offset: int) -> int {
    cnt: int = 0
    for item in x..=y {
        if item in set {
            cnt += int(item - x) + offset
        }
    }
    return cnt
}

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1
	}
	defer delete(data, context.allocator)

    elfs: [3]Item_Types = {}
    elf_cnt: int = 0
    badge_cnt: int = 0
    priorities_cnt: int = 0
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        first_comp: Item_Types = {}
        second_comp: Item_Types = {}
        half_length: int = len(line) / 2

        for index in 0..<half_length {
            first_comp += {rune(line[index])}
            second_comp += {rune(line[half_length + index])}
        }

        // NOTE This will only contain one item, no idea how to access it though
        item_to_remove: Item_Types = first_comp & second_comp
        priorities_cnt += count(&item_to_remove, 'A', 'Z', 27) + count(&item_to_remove, 'a', 'z', 1)

        // NOTE This is again only one element, but still no idea how to access it
        elfs[elf_cnt] = first_comp | second_comp
        elf_cnt += 1
        if elf_cnt > 2 {
            common_element := elfs[0] & elfs[1] & elfs[2]
            badge_cnt += count(&common_element, 'A', 'Z', 27) + count(&common_element, 'a', 'z', 1)
            elf_cnt = 0
        }
    }

    return priorities_cnt, badge_cnt
}

main :: proc() {
    x, y := solve("day03/test.txt")
    assert(x == 157)
    assert(y == 70)
    x, y = solve("day03/input.txt")
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
