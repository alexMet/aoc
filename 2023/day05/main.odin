package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

N :: 7
Range :: struct{source, destination, length: int}
// maps := [?]string{
//     "seed-to-soil",
//     "soil-to-fertilizer",
//     "fertilizer-to-water",
//     "water-to-light",
//     "light-to-temperature",
//     "temperature-to-humidity",
//     "humidity-to-location",
// }

find_location :: proc(almanac: ^[N][dynamic]^Range, seed: int) -> int {
    point := seed
    for m in 0..<N {
        for range in almanac[m] {
            if point >= range.source && point <= range.source + range.length - 1 {
                point = point - range.source + range.destination
                break
            }
        }
    }
    return point
}

solve :: proc(filepath: string) -> (int, int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return -1, -1
	}
	defer delete(data, context.allocator)

    it := string(data)
    line, _ := strings.split_lines_iterator(&it)
    seeds_line := strings.split(line, " ")[1:]
    seeds := make([]int, len(seeds_line))
    for s, i in seeds_line {
        seeds[i] = strconv.atoi(s)
    }

    almanac: [N][dynamic]^Range
    for m in 0..<N {
        almanac[m] = make([dynamic]^Range)
    }
    defer {
        for value in almanac {
            delete(value)
        }
    }

    map_index: int = -1
    ranges: ^[dynamic]^Range
	for line in strings.split_lines_iterator(&it) {
        if line == "" {
            strings.split_lines_iterator(&it)
            map_index += 1
            ranges = &almanac[map_index]
        }
        else {
            values := strings.split(line, " ")
	        range := new(Range, context.allocator)
            range.source = strconv.atoi(values[1])
            range.destination = strconv.atoi(values[0])
            range.length = strconv.atoi(values[2])
            append(ranges, range)
        }
    }

    lowest_location := 1_000_000_000
    for seed in seeds {
        lowest_location = min(lowest_location, find_location(&almanac, seed))
    }

    /* TODO Improve this, because it's slow af */
    any_lowest_location := 1_000_000_000
    for i in 0..<len(seeds) / 2 {
        min_seed := seeds[2 * i]
        max_seed := seeds[2 * i] + seeds[2 * i + 1] - 1
        fmt.println("---", min_seed, max_seed, max_seed - min_seed)

        for seed in min_seed..=max_seed {
            any_lowest_location = min(any_lowest_location, find_location(&almanac, seed))
        }
    }

    return lowest_location, any_lowest_location
}

main :: proc() {
    x, y := solve("2023/day05/test.txt")
    fmt.println(x, y)
    assert(x == 35)
    assert(y == 46)
    x, y = solve("2023/day05/input.txt")
    assert(x == 379811651)
    assert(y == 27992443)
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
