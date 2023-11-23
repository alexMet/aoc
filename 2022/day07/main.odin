package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

TOTAL_DISK_SIZE :: 70_000_000
MIN_UPDATE_SIZE :: 30_000_000
MAX_DIR_SIZE :: 100_000

File :: struct {
    parent: ^File,
    name: string,
    size: u128,
    files: map[string]^File,
}

calculate_size :: proc(acc: ^u128, dir: ^File) -> u128 {
    if len(dir.files) == 0 {
        return dir.size
    }
    for _, file in dir.files {
        size := calculate_size(acc, file)
        acc^ += size if size <= MAX_DIR_SIZE else 0
        dir.size += size
    }
    return dir.size
}

calculate_deletion_size :: proc(acc: ^u128, free_space: u128, dir: ^File) {
    for _, file in dir.files {
        acc^ = file.size if free_space + file.size > MIN_UPDATE_SIZE && file.size < acc^ else acc^
        calculate_deletion_size(acc, free_space, file)
    }
}

solve :: proc(filepath: string) -> (u128, u128) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return 0, 0
	}
	defer delete(data, context.allocator)

    root_dir: ^File
    current_dir: ^File
    it := string(data)
	for line in strings.split_lines_iterator(&it) {
        tokens := strings.split(line, " ")

        switch tokens[0] {
        case "$":
            switch tokens[1] {
            case "cd":
                dirname := tokens[2]
                switch dirname {
                case "..":
                    current_dir = current_dir.parent
                case "/":
                    if root_dir == nil {
                        root_dir = new(File, context.allocator)
                        root_dir.name = dirname
                        root_dir.parent = nil
                    }
                    current_dir = root_dir
                case:
                    current_dir = current_dir.files[dirname]
                }
            case "ls":  // Do nothing here
            }
        case "dir":
            dirname := tokens[1]
            if dirname not_in current_dir.files {
                new_dir := new(File)
                new_dir.parent = current_dir
                new_dir.name = dirname
                current_dir.files[dirname] = new_dir
            }
        case:
            size, _ := strconv.parse_u128(tokens[0])
            current_dir.size += size
        }
	}

    top_dir_sizes_sum: u128
    calculate_size(&top_dir_sizes_sum, root_dir)

    min_dir_size_to_delete: u128 = TOTAL_DISK_SIZE
    free_space: u128 = TOTAL_DISK_SIZE - root_dir.size
    calculate_deletion_size(&min_dir_size_to_delete, free_space, root_dir)

    return top_dir_sizes_sum, min_dir_size_to_delete
}

main :: proc() {
    x, y := solve("2022/day07/test.txt")
    assert(x == 95437)
    assert(y == 24933642)
    x, y = solve("2022/day07/input.txt")
	fmt.println("1st part:", x)
    fmt.println("2nd part:", y)
}
