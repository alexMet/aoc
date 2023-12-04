package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode"

DIGIT_WORDS :: [9]string {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

to_digit :: proc(x: rune) -> int {
    return int(x - '1' + 1)
}

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1
	}
	defer delete(data, context.allocator)

    sum_of_calibrations: int 
    sum_of_real_calibrations: int
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        first: int = 0
        first_index: int = 100_000
        last: int = 0
        last_index: int = -1

        for x, i in line {
            if first == 0 && unicode.is_digit(x) {
                first, first_index = to_digit(x), i 
            }
            if unicode.is_digit(x) {
                last, last_index = to_digit(x), i 
            }
        }
        sum_of_calibrations += 10 * first + last

        // This is awful, but I can't understand how core:text/match works :)
        for word, digit in DIGIT_WORDS {
            word_index := strings.index(line, word)

            if word_index >= 0 {
                min_index := word_index
                max_index := word_index
                word_last_index := strings.last_index(line, word)
                if word_last_index >= 0 && word_index != word_last_index {
                    min_index = min(word_index, word_last_index)
                    max_index = max(word_index, word_last_index)
                }

                if min_index < first_index {
                    first, first_index = digit + 1, min_index
                }
                if max_index > last_index {
                    last, last_index = digit + 1, max_index
                }
            }
        }
        sum_of_real_calibrations += 10 * first + last
	}

    return sum_of_calibrations, sum_of_real_calibrations
}

main :: proc() {
    x, y := solve("2023/day01/test.txt")
    assert(x == 142)
    assert(y == 142)
    x, y = solve("2023/day01/test2.txt")
    assert(x == 209)
    assert(y == 281)
    x, y = solve("2023/day01/input.txt")
    assert(x == 56042)
    assert(y == 55358)
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
