package main

import "core:container/queue"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

Op :: enum{Plus, Dot, Concat}
Node :: struct{
    acc, index: int,
    with_concat: bool,
}

solve :: proc(filepath: string) -> (int, int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        fmt.println("File doesn't exist!")
        return -1, -1
    }
    defer delete(data, context.allocator)
    
    total_calibration_result: int = 0
    total_calibration_result_with_concat: int = 0
    qq: queue.Queue(Node) 
    defer queue.destroy(&qq)

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        equation := strings.split(line, ": ")
        defer delete(equation)

        target := strconv.atoi(equation[0])
        numbers := strings.split(equation[1], " ")
        defer delete(numbers)

        holds, holds_with_concat: bool = false, false
        queue.init(&qq, capacity=1000)
        queue.push(&qq, Node{strconv.atoi(numbers[0]), 0, false})
        for queue.len(qq) > 0 {
            n := queue.pop_front(&qq)
            if n.index == len(numbers) - 1 {
                if n.acc == target {
                    if !n.with_concat && !holds {
                        holds = true
                        total_calibration_result += target
                    }
                    if !holds_with_concat {
                        holds_with_concat = true
                        total_calibration_result_with_concat += target
                    }
                }
                continue
            }

            new_index := n.index + 1
            // Handle addition + operator
            new_acc := n.acc + strconv.atoi(numbers[new_index])
            if new_acc <= target do queue.push(&qq, Node{new_acc, new_index, n.with_concat})

            // Handle multiplication * operator
            new_acc = n.acc * strconv.atoi(numbers[new_index])
            if new_acc <= target do queue.push(&qq, Node{new_acc, new_index, n.with_concat})

            // Handle concatination || operator
            buf: [100]byte
            result := strconv.itoa(buf[:], n.acc)
            new_acc = strconv.atoi(strings.join([]string{result, numbers[new_index]}, ""))
            if new_acc <= target do queue.push(&qq, Node{new_acc, new_index, true})
        }
    }

    return total_calibration_result, total_calibration_result_with_concat
}

main :: proc() {
    x, y := solve("2024/day07/test.txt")
    assert(x == 3749)
    assert(y == 11387)
    x, y = solve("2024/day07/input.txt")
    fmt.println("1st part:", x)
    assert(x == 1582598718861)
    fmt.println("2nd part:", y)
    assert(y == 165278151522644)
}
