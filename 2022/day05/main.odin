package main

import "core:container/queue"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"
import "core:strconv"

QQ :: queue.Queue(rune)

print_back_elems :: proc(q: ^[]QQ, cnt: int) {
    for i in 0..<cnt {
        fmt.print(queue.peek_back(&q[i])^)
    }
    fmt.println()
}

solve :: proc(filepath: string, qq_cnt: int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.println("File doesn't exist!")
		return
	}
	defer delete(data, context.allocator)

    // Create the queues list and initialize each one
    capacity := queue.DEFAULT_CAPACITY * 6 if qq_cnt == 9 else queue.DEFAULT_CAPACITY
    qq_9000 := make([]QQ, qq_cnt)
    qq_9001 := make([]QQ, qq_cnt)
    for i in 0..<qq_cnt {
        queue.init(&qq_9000[i], capacity=capacity)
        queue.init(&qq_9001[i], capacity=capacity)
    }
    defer delete(qq_9000)
    defer delete(qq_9001)
    defer {
        for i in 0..<qq_cnt {
            queue.destroy(&qq_9000[i])
            queue.destroy(&qq_9001[i])
        }
    }

    // Add the elements to each queue
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        if line[1] == '1' {
            // Consume the extra empy line
            strings.split_lines_iterator(&it)
            break
        }

        for i in 0..<qq_cnt {
            r := rune(line[4 * i + 1])
            if r != ' ' {
                queue.push_front(&qq_9000[i], r)
                queue.push_front(&qq_9001[i], r)
            }
        }
    }

    // Move crates around as per the instructions
	for line in strings.split_lines_iterator(&it) {
        tokens := strings.split(line, " ")
        crate_cnt := strconv.atoi(tokens[1])
        from := strconv.atoi(tokens[3]) - 1
        to := strconv.atoi(tokens[5]) - 1

        crates := make([]rune, crate_cnt)
        for i in 0..<crate_cnt {
            queue.append(&qq_9000[to], queue.pop_back(&qq_9000[from]))
            crates[i] = queue.pop_back(&qq_9001[from])
        }

        slice.reverse(crates)
        queue.push_back_elems(&qq_9001[to], ..crates)
        delete(crates)
	}

    // Print the top elements from each queue
    print_back_elems(&qq_9000, qq_cnt)
    print_back_elems(&qq_9001, qq_cnt)
}

main :: proc() {
    solve("day05/test.txt", 3)
    fmt.println("---")
    solve("day05/input.txt", 9)
}
